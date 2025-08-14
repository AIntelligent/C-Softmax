# Experimental Materials for "C-Softmax: A Contextual-Softmax Operator Incorporating Row and Column Priorities

This folder contains the experimental validation of all theorems for the contextual softmax (C-Softmax) operator and its bioinformatics application for *Hemoglobin-β (HBB)*.

## Files
- `c_softmax_experiments_2025_v1.zip`:
- `c_softmax_numpy_final.ipynb`: Interactive Jupyter Notebook (compatible with Google Colab).
- `c_softmax_numpy_final_ipynb - Colab.pdf`: Results and visualizations of all tests.
- `c_softmax_numpy_final.py`: Standalone Python implementation.
- `fig1_limit_behavior.png`: C-Softmax Limit Behavior (Teorem 5) graph.
- `fig2_alpha_learning.png`: Adaptive Learning of α (Teorem 2) graph.
- `fig3_entropy_temp.png`: Entropy-Temperature Sensitivity (Teorem 7) graph.
- `full_outputs.txt`: All test results are here.
- `HBB.zip`: All the ingredients required for *Hemoglobin-β (HBB)*.
  - `P68871.fasta`: This a bioinformatics file in FASTA fmat containing the *Hemoglobin-β* protein sequence from the **UniProt (Universal Protein Resource)** database.
  - `last_alignment_data.txt`, `final_alignment_used.txt` and `final_alignment.clustal`: This is a *Hemoglobin-β* protein alignment file created in Clustal format.
  - `C-Softmax_HBB_Notebook_v2_en.ipynb - Colab.pdf`: Results of HBB tests.
  - `C_Softmax_HBB_Notebook_v2_en.ipynb`: Interactive Jupyter Notebook (compatible with Google Colab).
  - `blosum62.txt`:

[Get the latest release](https://github.com/AIntelligent/C-Softmax/releases/latest)

## Installation

If you don't have the Python interpreter, get the latest Python version from [here](https://www.python.org/downloads/).

```bash
pip install numpy matplotlib 
python c_softmax_numpy_final.py
