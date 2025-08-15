# Sensirion Raspberry Pi I²C SPS30 Driver

The repository provides a driver for setting up a SPS30 sensor
to run on a Raspberry Pi over I²C.

<img src="images/product-image-sps30.png" width="300px">

Click [here](https://sensirion.com/products/catalog/SPS30) to learn more about the Sensirion SPS30 sensor.


Not all sensors of this driver family support all measurements.
In case a measurement is not supported by all sensors, the products that
support it are listed in the API description.



The default I²C address of [SPS30](https://sensirion.com/products/catalog/SPS30) is **0x69**.



## Connect the sensor

Your sensor has 5 different connectors: VDD, SDA, SCL, SEL, GND.
Use the following pins to connect your SPS30:

| *SPS30* | *Cable Color*  |   *Raspberry Pi*   |
| :----------------: | -------------- | ------------------ |
| VDD | red | Pin 2
| SDA | green | Pin 3
| SCL | yellow | Pin 5
| SEL | blue | Pin 9
| GND | black | Pin 6


<img src="images/raspi-i2c-pinout-5V-SEL.png" width="400px">


### Detailed sensor pinout

<img src="images/product-pinout-sps30.jpg" width="300px">

| *Pin* | *Cable Color* | *Name* | *Description*  | *Comments* |
|-------|---------------|:------:|----------------|------------|
| 1 | red | VDD | Supply Voltage | 5V
| 2 | green | SDA | I2C: Serial data input / output |
| 3 | yellow | SCL | I2C: Serial clock input |
| 4 | blue | SEL | Interface select | Pull to GND to select I2C
| 5 | black | GND | Ground |



## Quick start example

- [Install the Raspberry Pi OS on to your Raspberry Pi](https://projects.raspberrypi.org/en/projects/raspberry-pi-setting-up)
- [Enable the I²C interface in the raspi-config](https://www.raspberrypi.org/documentation/configuration/raspi-config.md)
- Download the SPS30 driver from [Github](https://github.com/Sensirion/raspberry-pi-i2c-sps30) and extract the `.zip` on your Raspberry Pi
- Connect the SPS30 sensor as explained in the [section above](#connect-the-sensor)

- Compile the driver
    1. Open a [terminal](https://projects.raspberrypi.org/en/projects/raspberry-pi-using/8)
    2. Navigate to the driver directory. E.g. `cd ~/raspberry-pi-i2c-sps30`
    3. Navigate to the subdirectory example-usage.
    4. Run the `make` command to compile the driver

       Output:
       ```
       rm -f sps30_i2c_example_usage
       cc -Os -Wall -fstrict-aliasing -Wstrict-aliasing=1 -Wsign-conversion -fPIC -I. -o sps30_i2c_example_usage  sps30_i2c.h sps30_i2c.c sensirion_i2c_hal.h sensirion_i2c.h sensirion_i2c.c \
           sensirion_i2c_hal.c sensirion_config.h sensirion_common.h sensirion_common.c sps30_i2c_example_usage.c
       ```
- Test your connected sensor
    - Run `./sps30_i2c_example_usage` in the same directory you used to
      compile the driver. You should see the measurement values in the console.

## Troubleshooting

### Building driver failed

If the execution of `make` in the compilation step 3 fails with something like

```bash
 make: command not found
```

your RaspberryPi likely does not have the build tools installed. Proceed as follows:

```
$ sudo apt-get update
$ sudo apt-get upgrade
$ sudo apt-get install build-essential
```


### Initialization failed

If you run `./sps30_i2c_example_usage` but do not get sensor readings but something like this instead

```
Error executing stop_measurement(): -1
Error executing read_serial_number(): -1
Error executing read_product_type(): -1
...
```
then go through the below troubleshooting steps.


-   Ensure that you connected the sensor correctly: All cables are fully
    plugged in and connected to the correct pin.
-   Ensure that I²C is enabled on the Raspberry Pi. For this redo the steps on
    "Enable the I²C interface in the raspi-config" in the guide above.
-   Ensure that your user account has read and write access to the I²C device.
    If it only works with user root (`sudo ./sps30_i2c_example_usage`), it's
    typically due to wrong permission settings. See the next chapter how to solve this.

### Missing I²C permissions

If your user is missing access to the I²C interface you should first verfiy
the user belongs to the `i2c` group.

```
$ groups
users input some other groups etc
```
If `i2c` is missing in the list add the user and restart the Raspberry Pi.

```
$ sudo adduser your-user i2c
Adding user `your-user' to group `i2c' ...
Adding user your-user to group i2c
Done.
$ sudo reboot
```

If that did not help you can make globally accessible hardware interfaces
with a udev rule. Only do this if everything else failed and you are
reasoably confident you are the only one having access to your Pi.

Go into the `/etc/udev/rules.d` folder and add a new file named
`local.rules`.
```
$ cd /etc/udev/rules.d/
$ sudo touch local.rules
```
Then add a single line `ACTION=="add", KERNEL=="i2c-[0-1]*", MODE="0666"`
to the file with your favorite editor.
```
$ sudo vi local.rules
```

## Contributing

**Contributions are welcome!**

This Sensirion library uses
[`clang-format`](https://releases.llvm.org/download.html) to standardize the
formatting of all our `.c` and `.h` files. Make sure your contributions are
formatted accordingly:

The `-i` flag will apply the format changes to the files listed.

```bash
clang-format -i *.c *.h
```

Note that differences from this formatting will result in a failed build until
they are fixed.


## License

See [LICENSE](LICENSE).