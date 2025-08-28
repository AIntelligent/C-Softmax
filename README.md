# Experimental Materials for "C-Softmax: A Contextual-Softmax Operator Incorporating Row and Column Priorities

This folder contains the experimental validation of all theorems for the contextual softmax (C-Softmax) operator and its bioinformatics application for *Hemoglobin-β (HBB)*.

> Kartal, Hakan Emre [hek@nula.com.tr](hek@nula.com.tr) [0000-0002-3952-7235](https://orcid.org/0000-0002-3952-7235)

## 📊 Comparative Summary Table: C-Softmax vs. Other Methods

The following table provides a comparative overview of C-Softmax with other Softmax-based
methods from both theoretical and practical perspectives.

| Method                  | Differentiability | Sparse Output | Context Integration | Temperature / Entropy Control | Calibration | Reparametrization | Notes |
|--------------------------|-------------------|---------------|----------------------|-------------------------------|-------------|-------------------|-------|
| **Softmax (classical)**  | Infinite ($$C^\infty$$)     | No            | No                   | None (unless $$\tau$$ added)         | Weak        | No                | Basic probability projection; smooth gradient. |
| **C-Softmax (this work)** | Infinite ($$C^\infty$$)    | No $$\dagger$$          | **Yes** ($$\vec{\alpha}, \vec{\omega}, \vec{\beta}$$)    | **Yes** (via $$\tau$$)               | Strong (context-dependent) | No | Context-aware probability projection with external priorities. |
| **Sparsemax** (Martins & Astudillo, 2016) | Piecewise differentiable | **Yes** | No | None | Mixed | No | Euclidean projection onto simplex; interpretability advantage. |
| **Gumbel-Softmax / Concrete** (Jang et al., 2017; Maddison et al., 2017) | Infinite ($$C^\infty$$, relaxation) | No | No | **Yes** (via $$\tau$$) | Indirect | **Yes** | Enables differentiable sampling of discrete variables (VAE, RL). |
| **Temperature Scaling** (Guo et al., 2017) | Infinite ($$C^\infty$$) | No | No | **Yes** (post-hoc $$\tau$$) | Strong (post-hoc) | No | Post-hoc calibration; does not change the decision rule. |
| **Label Smoothing** (Szegedy et al., 2016) | Infinite ($$C^\infty$$) | No | No | Indirect (target distribution smoothing) | Typically improves | No | Reduces overconfidence; mixes targets. |

---
† C-Softmax provides full support; however, extreme values of context parameters (e.g., α)  
may lead to near-zero probabilities, resulting in effectively sparse distributions.  

📌 Notably, $$\frac{\partial L}{\partial \ln \alpha_i} = p_i - y_i$$ allows context parameters to be directly optimized within gradient-based learning frameworks.

## Files
- `CSoftmaxTest.dpr`: It is the Pascal language implementation of the C-Softmax function in the article.
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

### Direct Download
[![DOI](https://zenodo.org/badge/1034360450.svg)](https://doi.org/10.5281/zenodo.16881842)

## Installation

If you don't have the Python interpreter, get the latest Python version from [here](https://www.python.org/downloads/).

```bash
pip install numpy matplotlib 
python c_softmax_numpy_final.py
```

This work was first submitted to TechRxiv on August 18, 2025 (Case #250826-000675, #250826-000685, #250827-000874, and #250828-000843)
