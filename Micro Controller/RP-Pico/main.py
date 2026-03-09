from machine import Pin, PWM, I2C
import time

distance_sensor = I2C(1, scl=Pin(15), sda=Pin(14), freq=400000)
i2c_master = I2C(0, sda=Pin(0), scl=Pin(1), freq=100000)

addr = 0x30

pollinator = Pin(13, Pin.OUT)
wheels = Pin(12, Pin.OUT)
stoppers = Pin(11, Pin.IN, Pin.PULL_DOWN)

servoY = PWM(Pin(6))
servoY.freq(100)

servoZ = PWM(Pin(10))
servoZ.freq(100)

IN1 = Pin(2, Pin.OUT)
IN2 = Pin(3, Pin.OUT)
IN3 = Pin(4, Pin.OUT)
IN4 = Pin(5, Pin.OUT)

pins = [IN1, IN2, IN3, IN4]

sequence = [
    [1,0,0,0],
    [0,1,0,0],
    [0,0,1,0],
    [0,0,0,1]
]

current_state = 1

def start_pollinator():
    pollinator.value(1)
    time.sleep(1)
    pollinator.value(0)


def set_angle_y(angle):
    duty = int(1000 + (angle / 180) * 8000)
    servoY.duty_u16(duty)

def set_angle_z(angle):
    duty = int(1000 + (angle / 180) * 8000)
    servoZ.duty_u16(duty)


def arduino_map(value, fromLow, fromHigh, toLow, toHigh):
    return toLow + (toHigh - toLow) * ((value - fromLow) / (fromHigh - fromLow))


def y_to_angle(y):
    return arduino_map(y, 0, 1023, 0, 180)


def z_to_angle(z):
    return arduino_map(z, 0, 1023, 0, 180)


def get_distance():
    distance_sensor.writeto_mem(0x29, 0x00, b'\x01')
    time.sleep_ms(40)
    data = distance_sensor.readfrom_mem(0x29, 0x1E, 2)
    distance = (data[0] << 8) | data[1]
    print(distance, "mm")
    return distance


def moveZAxis():
    distance = get_distance()
    angle = z_to_angle(distance)

    for a in range(0, 181, 2):
        set_angle_z(a)
        time.sleep(0.02)

    start_pollinator()

    for a in range(180, -1, -2):
        set_angle_z(a)
        time.sleep(0.02)


def moveYAxis(y):
    angle = y_to_angle(y)

    for a in range(0, 181, 2):
        set_angle_y(a)
        time.sleep(0.02)

    for a in range(180, -1, -2):
        set_angle_y(a)
        time.sleep(0.02)


def set_step(step):
    for i in range(4):
        pins[i].value(step[i])


def power_off():
    for p in pins:
        p.value(0)


def moveXAxis(x):
    while x > 0:
        for step in sequence:
            set_step(step)
            time.sleep(0.002)
        x -= 1


def homeXAxis():
    while not stoppers.value():
        for step in sequence:
            set_step(step)
            time.sleep(0.002)


def moveArm(x, y):
    moveXAxis(x)
    power_off()
    moveYAxis(y)
    homeXAxis()


def moveRover():
    wheels.value(1)
    time.sleep(3)
    wheels.value(0)
    print("stoped")


def roverOperation():
    global current_state

    try:
        # data = i2c_master.readfrom(addr, 4)

        status = 1 # data[0]
        x = 120 # data[1]
        y = 200 # data[2]
        checksum =  1 # data[3]
        print(status)
        print(x)
        print(y)
        print(checksum)
        if checksum == 1:
        # if checksum == (status ^ x ^ y):
            current_state = 0
            
            if status == 1:
                print("pollination started")
                moveArm(x, y)
                moveRover()

            elif status == 2:
                print("rover moves")
                moveRover()

            else:
                print("rover in idel")
                time.sleep(5)

            current_state = 1

    except Exception as e:
        print("I2C error:", e)


def main():
    global current_state

    # Test
    while True:
        roverOperation()
        time.sleep(1)

    # print("starting point")

    # while True:

    #     if current_state == 1:
    #         try:
    #             i2c_master.writeto(addr, b"1")
    #             print("Sent:", current_state)

    #             time.sleep_ms(100)
    #             roverOperation()

    #         except Exception as e:
    #             print("I2C error:", e)

    #     else:
    #         try:
    #             i2c_master.writeto(addr, b"0")
    #             print("Sent:", current_state)
    #             time.sleep(1)

    #         except Exception as e:
    #             print("I2C error:", e)


if __name__ == "__main__":
    main()