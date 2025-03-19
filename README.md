# Skeletonisation Evaluation Toolbox

This repository accompanies the paper *"Skeletonization Quality Evaluation: Geometric Metrics for Point Cloud Analysis in Robotics"*.

## Overview

This repository provides a toolbox for evaluating skeletonisation performance in shape representation. It includes scripts for both quick start and result visualisation, along with tools for quantitative analysis.

## Features

- Evaluates skeletonisation quality using various metrics.
- Provides quantitative graphical results.
- Supports visualisation of evaluation results.

## Requirements

- **MATLAB**: Version R2022b or later recommended.
- **Python**: Version 3.10 or later recommended.
- **GUDHI package**: Version 3.10 or later. [Documentation](https://gudhi.inria.fr/doc/latest/)

Ensure that Python is properly installed and accessible from MATLAB.

## Installation

1. Install MATLAB (R2022b or later).
2. Install Python (>=3.10) with the required GUDHI package:
   ```bash
   pip install gudhi
   ```
3. Ensure MATLAB is configured to use the correct Python environment.

## Quick Start

Run the demo script to evaluate skeletonisation performance:

```matlab
run('demo/example.m')
```

To visualise the results:

```matlab
run('demo/visualisation.m')
```

## Graphical results

Precomputed graphical results are provided in the `Graphical_results` folder.

## License

This project is licensed under the MIT License.

