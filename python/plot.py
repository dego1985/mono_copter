import time
from typing import List
import numpy as np
import quaternion
from quaternion import quaternion as quat

import pyqtgraph as pg
import pyqtgraph.opengl as gl
from pyqtgraph.Qt import QtCore
import serial


PORT = "/dev/cu.usbmodem1101"

np.set_printoptions(precision=3)
e = np.eye(3)
eq = np.array(
    [
        quat(0, 1, 0, 0),
        quat(0, 0, 1, 0),
        quat(0, 0, 0, 1),
    ]
)


def setup_serial() -> serial.Serial:
    ser = serial.Serial()
    # ser.baudrate = 115200
    ser.baudrate = 2000000
    ser.timeout = None  # タイムアウトの時間
    ser.port = PORT

    try:
        ser.open()
        print("open " + PORT)
    except Exception as e:
        print("can't open " + PORT)
        print(e)
        quit()

    return ser


class Axes3D:
    def __init__(self, scale=1.0) -> None:
        self.scale = scale
        xs = np.eye(3)
        self.arrows = [
            gl.GLLinePlotItem(
                pos=np.array([[0, 0, 0], xs[i]]),
                color=(*xs[i], 1),
                width=18,
                antialias=True,
            )
            for i in range(3)
        ]

    def addItemTo(self, w: gl.GLViewWidget):
        for i in range(3):
            w.addItem(self.arrows[i])

    def set_quat(self, q: np.ndarray, x: np.ndarray = quat(0, 0, 0, 0)):
        eq2 = q * eq * q.conj()
        offset = np.array([x.x, x.y, x.z])
        for i in range(3):
            pos = np.array([[0, 0, 0], [eq2[i].x, eq2[i].y, eq2[i].z]])
            self.arrows[i].setData(pos=pos * self.scale + offset)


class Cube3D:
    def __init__(self, scale=1.0) -> None:
        self.scale = scale
        xs = np.eye(3)
        self.arrows = [
            gl.GLLinePlotItem(
                pos=np.array([[0, 0, 0], xs[i]]),
                color=(*xs[i], 1),
                width=9,
                antialias=True,
            )
            for i in range(3)
        ]

    def addItemTo(self, w: gl.GLViewWidget):
        for i in range(3):
            w.addItem(self.arrows[i])

    def set_quat(self, q: np.ndarray, x: np.ndarray = quat(0, 0, 0, 0)):
        eq2 = q * eq * q.conj()
        offset = np.array([x.x, x.y, x.z])
        for i in range(3):
            pos = np.array([[0, 0, 0], [eq2[i].x, eq2[i].y, eq2[i].z]])
            self.arrows[i].setData(pos=pos * self.scale + offset)


class Arrow3D:
    def __init__(self, color, scale=1) -> None:
        self.scale = scale
        self.arrow = gl.GLLinePlotItem(
            pos=np.array([[0, 0, 0], [1, 0, 0]]),
            color=color,
            width=5,
            antialias=True,
        )

    def addItemTo(self, w: gl.GLViewWidget):
        w.addItem(self.arrow)

    def set_quat(self, q: np.ndarray):
        self.arrow.setData(
            pos=np.array([[0, 0, 0], [q.x, q.y, q.z]]) * self.scale
        )


class Scatter3D:
    def __init__(self, color, scale=1, r=None) -> None:
        self.r = r
        self.scale = scale
        self.points: List[np.ndarray] = []
        self.center = np.zeros(3, np.float32)
        self.scatter = gl.GLScatterPlotItem(
            pos=[], color=color, size=0.1, pxMode=False
        )

    def addItemTo(self, w: gl.GLViewWidget):
        w.addItem(self.scatter)

    def set_quat(self, q: np.ndarray):
        # update point
        v = quaternion.as_vector_part(q)
        if len(self.points) == 0:
            self.points.append(v)
        else:
            prev_normalized = normalize(self.points[-1])
            curr_normalized = normalize(v)
            diff_angle = np.linalg.norm(curr_normalized - prev_normalized)
            if diff_angle > 0.1:
                self.points.append(v)
                print(self.points[-1])

        # update center
        mag_correct = np.array(self.points) - self.center[np.newaxis, :]
        rs = np.linalg.norm(mag_correct, axis=-1, keepdims=True)
        if self.r is None:
            r = np.mean(rs)
        else:
            r = self.r
        self.center += 0.01 * np.mean(
            (rs - r) * normalize(mag_correct), axis=0
        )
        self.scatter.setData(
            pos=(np.array(self.points) - self.center) * self.scale
        )

        # remove outlier
        self.points = [
            x for x, r1 in zip(self.points, rs) if abs(r1 - r) / r < 0.3
        ]


def normalize(v: np.ndarray):
    norm = np.linalg.norm(v, axis=-1, keepdims=True)
    return v / norm


scatter = False
mag_show = False
acc_show = True
v_show = True
raw_show = False
z_off = True


class myApp:
    def __init__(self) -> None:
        # serial
        self.ser = setup_serial()

        pg.mkQApp("serial arror")
        w = gl.GLViewWidget()
        w.show()
        w.setWindowTitle("Arrow")
        w.setCameraPosition(distance=1)

        # grid
        g = gl.GLGridItem()
        g.scale(0.1, 0.1, 0.1)
        w.addItem(g)

        # pose
        self.axes = Axes3D(scale=0.05)
        self.axes.addItemTo(w)

        if acc_show:
            if raw_show:
                # acc raw arrow
                self.acc_raw_arrow = Arrow3D([1, 1, 1, 0.5], scale=0.01)
                self.acc_raw_arrow.addItemTo(w)

            # acc arrow
            self.acc_arrow = Arrow3D([1, 1, 1, 1], scale=0.01)
            self.acc_arrow.addItemTo(w)

        if v_show:
            # acc arrow
            self.v_arrow = Arrow3D([1, 0, 1, 1], scale=0.05)
            self.v_arrow.addItemTo(w)

        if mag_show:
            if raw_show:
                # mag raw arrow
                self.mag_raw_arrow = Arrow3D([1, 0, 1, 0.5], scale=0.001)
                self.mag_raw_arrow.addItemTo(w)

            # mag arrow
            self.mag_arrow = Arrow3D([1, 0, 1, 1], scale=0.001)
            self.mag_arrow.addItemTo(w)

        # time counter
        self.prev_time = time.perf_counter()

        if scatter:
            # mag scatter
            self.mag_scatter = Scatter3D(
                color=(1, 0, 1, 0.3), scale=0.01, r=120
            )
            self.mag_scatter.addItemTo(w)

            # acc scatter
            self.acc_scatter = Scatter3D(
                color=(1, 1, 1, 0.3), scale=0.1, r=9.80
            )
            self.acc_scatter.addItemTo(w)

        self.acc_ma = quat()

    def update(self):
        # read serial
        line = self.ser.readline().decode("utf-8").split(",")
        if len(line) != 1 + 3 * 3 + 3 * 3 + 4 + 3 * 3 or line[0] != "s":
            return
        self.ser.flushInput()
        line = line[1:]
        array = np.array(line).astype(np.float32).tolist()

        i = 0
        acc_raw = np.quaternion(0, *array[i : (i := i + 3)])
        gyro_raw = np.quaternion(0, *array[i : (i := i + 3)])
        mag_raw = np.quaternion(0, *array[i : (i := i + 3)])

        acc = np.quaternion(0, *array[i : (i := i + 3)])
        gyro = np.quaternion(0, *array[i : (i := i + 3)])
        mag = np.quaternion(0, *array[i : (i := i + 3)])

        q = np.quaternion(*array[i : (i := i + 4)])
        velocity = -np.quaternion(0, *array[i : (i := i + 3)])
        x = np.quaternion(0, *array[i : (i := i + 3)])
        acc_w = np.quaternion(0, *array[i : (i := i + 3)])

        if z_off:
            x.z = 0
            velocity.z = 0
            acc_w.z = 0

        # update position
        self.axes.set_quat(q, x)
        if acc_show:
            self.acc_arrow.set_quat(acc_w * 10)
            # self.acc_arrow.set_quat(q * acc * q.conj())
            if raw_show:
                self.acc_raw_arrow.set_quat(acc)
        if v_show:
            self.v_arrow.set_quat(velocity * 10)
        if mag_show:
            self.mag_arrow.set_quat(q * mag * q.conj())
            if raw_show:
                self.mag_raw_arrow.set_quat(
                    mag_raw - quat(0, *self.mag_scatter.center)
                )

        if scatter:
            # update mag scatter
            self.mag_scatter.set_quat(mag_raw)
            print(f"{self.mag_scatter.center = }")

            # update acc scatter
            self.acc_scatter.set_quat(acc_raw)
            print(f"{self.acc_scatter.center = }")

        # time counter
        now_time = time.perf_counter()
        fps = 1 / (now_time - self.prev_time)
        self.prev_time = now_time

        # print
        self.acc_ma = self.acc_ma * 0.99 + 0.01 * acc_raw
        print(quaternion.as_vector_part(self.acc_ma))

    def start(self):
        t = QtCore.QTimer()
        t.timeout.connect(self.update)
        t.start(0)
        pg.exec()


if __name__ == "__main__":
    app = myApp()
    app.start()
