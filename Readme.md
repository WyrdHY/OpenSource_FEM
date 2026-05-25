# OpenSource FEM v1.0

I made this myself so you do not need COMSOL when you just need to quick mode index. The accuracay has been verified to be less than 0.01% compared to COMSOL result. Increasing mesh quality will converge to COMSOL result.

### Supported Structures
* **Ridge Waveguide**
  ![Ridge Waveguide Structure](./Miscellaneous/1.0%20ridge.png)

### How to Use
1. Set your MATLAB working directory to `OpenSource FEM_1.0`.
2. Open `Ridge_Main.m` located inside the `Ridge_waveguide` folder.
3. Input your structure's geometry parameters (in $\mu\text{m}$) and hit **Run**.