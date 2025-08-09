# Experimental Material for "CSoftmax: A Contextual Softmax Operator Incorporating Row and Column Priorities"

This folder contains experimental verification of all theorems defined for the contextual softmax (C-Softmax) operator.

## Files
- `c_softmax_numpy_final_ipynb - Colab.pdf`: Results and visualizations of all tests.
- `c_softmax_numpy_final.ipynb`: Interactive Jupyter Notebook (compatible with Google Colab).
- `c_softmax_numpy_final.py`: Standalone Python implementation.
- `fig1_limit_behavior.png`: C-Softmax Limit Behavior (Teorem 5) graph.
- `fig2_alpha_learning.png`: Adaptive Learning of α (Teorem 2) graph.
- `fig3_entropy_temp.png`: Entropy-Temperature Sensitivity (Teorem 7) graph.
- `full_outputs.txt`: All test results are here.

[Get the latest release](https://github.com/AIntelligent/C-Softmax/releases/latest)

## Installation

If you don't have the Python interpreter, get the latest Python version from [here](https://www.python.org/downloads/).

```bash
pip install numpy matplotlib
python c_softmax_numpy_final.py
