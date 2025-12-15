Spin wave calculations for iron
Tue 13 May 14:29:26 BST 2025

## Non-interacting transverse susceptibility

The non-interacting transverse susceptibility is calculated using the sum-over-states approach, 
see: [callaway][^Callaway],[adler][^Adler],[wiser][^Wiser],[exciting][^exciting].

$$|i,k,s\rangle$$ single-particle eigenstates with some band index, wave vector and spin.

$$
\begin{aligned}
\chi^{0,+-}_{GG'} (q;\omega) = \frac{1}{\pi} & \biggl(
        \sum\limits_{i,k,\uparrow}^{\text{occ}} 
        \sum\limits_{j,k+q,\downarrow}^{\text{unocc}}
        \frac{
            \langle i,k,\uparrow     | e^{-(q+G).r} | j,k+q,\downarrow \rangle
            \langle j,k+q,\downarrow | e^{(q+G').r} | i,k,\uparrow     \rangle
        }{
            e_{i,k,\uparrow} - e_{j,k+q,\downarrow} + \omega + i\eta
        }
        +\\
        &\sum\limits_{i,k,\uparrow}^{\text{unocc}} 
        \sum\limits_{j,k+q,\downarrow}^{\text{occ}}
        \frac{
            \langle i,k,\uparrow     | e^{-(q+G).r} | j,k+q,\downarrow \rangle
            \langle j,k+q,\downarrow | e^{(q+G').r} | i,k,\uparrow     \rangle
        }{
            -(e_{i,k,\uparrow} - e_{j,k+q,\downarrow}) - \omega + i\eta
        }
        \biggr)
\end{aligned}
$$

This object is constructed in a [mixed product basis][^mpbasis] (instead of plane waves $$G$$). 

The imaginary part is evaluated and the real part is calculated by Kramers-Kronig.  The two parts
to the expression are evaluated separately.  The integration over $$k$$ for each $$q$$ is done using a 
linear tetrahedron method (which captures the zero-temperature Drude part of the susceptibility).

The units of $$\chi^0$$ are $$\mu_B^2 / Rydberg$$.

[^Adler]:https://journals.aps.org/pr/pdf/10.1103/PhysRev.126.413
[^Callaway]:https://journals.aps.org/prb/abstract/10.1103/PhysRevB.24.6491
[^exciting]:https://iopscience.iop.org/article/10.1088/0953-8984/26/36/363202/pdf
[^mpbasis]:https://journals.aps.org/prb/abstract/10.1103/PhysRevB.76.165106
[^Wiser]:https://journals.aps.org/pr/pdf/10.1103/PhysRev.129.62

## Site projected susceptibility

The non-interacting transverse susceptibility, expressed in the mixed product basis, can be 
projected onto atomic sites.

$$
\chi^{0,+-}_{ij} = \left[\sum_{L,L'} \langle R_{L,\uparrow}(r_i) R_{L',\downarrow}(r_i) | B_I \rangle \right] 
                   \chi^{0,+-}_{IJ}
                   \left[\sum_{L,L'} \langle B_J | R_{L,\uparrow}(r_j) R_{L',\downarrow}(r_j) \rangle \right]
$$

Where $$R_{L}(r_i)$$ are the partial waves at site $$i$$, normalised to unity.

This downfolds the large $$G,G'$$ (or $$r,r'$$) dependent susceptibility matrix onto one indexed by 
site $$i,j$$ alone.  For a single site in the unit cell, this is a scalar (for each wave vector and 
frequency).

The summation over $L$,$L'$ can optionally be stopped at $L=L-L'=0$ (spherical approximation).

## Rigid spin approximation for enhanced susceptibility

The site projected susceptibility has two significant advantages over the full matrix object: it 
allows a simple connection to the Heisenberg exchange, which can be defined as the inverse of the 
susceptibility, and it allows the evaluation of the kernel relating the non-interacting 
susceptibility with the full response according to the rigid spin approximation.

$$
[\chi^{RSA}(q;\omega)]^{-1} = [\chi^0(q;\omega)]^{-1} - U^{RSA}(\omega)
$$

These are site indexed matrices.  Making the assumption that $U$ is local, it can be calculated 
using only the requirement that spin waves (in $\chi$) obey Goldstone's theorem, 
see: [TK & MvS][^kotani], [Pavel Buczek][^pavel], [Samir Lounis][^lounis].

$$
U_i(\omega) = \sum_j [\chi^0(q=0;\omega)]^{-1}_{ij} \, m_j/m_i - \omega/m_i
$$

With $m_i$ the magnetisation at each site.

The static form involves using the $\omega=0$ $U$ for evaluating $\chi^{RSA}$ at all $\omega$.

[^pavel]:https://journals.aps.org/prb/abstract/10.1103/PhysRevB.84.174418
[^kotani]:https://iopscience.iop.org/article/10.1088/0953-8984/20/29/295214
[^lounis]:https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.105.187205

## Description of the calculation

Body centred cubic iron with lattice constant 2.867 Å is calculated using the local density 
approximation (LDA) and quasiparticle self-consistent form of the $GW$ approximation (QSGW).

| method | n(E_F) (states/Ryd) | total moment (µ_B) | muffin-tin (µ_B) |
|--------|---------------------|--------------------|------------------|
| LDA    | 14.51               | 2.200              | 2.231            |
| QSGW   | 16.80               | 2.267              | 2.310            |

The QSGW self-energy is evaluated on a mesh of 12 x 12 x 12 q-points.

### command summary

```
    lmf --v8 ctrl.fe > llmf  # self-consistent calculation (QSGW if sigm file present, else LDA)
    lmgw.sh --chipm ctrl.fe  # susceptibility calculation (produces chipm.h5 file)
    lmf --x0j~rsa~fbz ctrl.fe    # RSA calculation (produces chipm_rsa.fe file, mapping IBZ->FBZ)
```

(Options to do with parallel execution have been removed.)

The crystal orientation, together with all other control parameters, is given in the file named
"ctrl.fe".

## Contents of the chipm_rsa file

| name   | kind    | dimension               | contents                                       |
|--------|---------|-------------------------|------------------------------------------------|
| chi0   | complex | nq * nw * nmbas * nmbas | bare susceptibility interpolated to new q,ω    |
|        |         |                         | units $\mu_B^2/Rydberg$                        |
| chirsa | complex | nq * nw * nmbas * nmbas | RSA susceptibility at interpolated q,ω         |
|        |         |                         | units $\mu_B^2/Rydberg$                        |
| mmom   | real    | nmbas                   | moment at magnetic sites $\mu_B$               |
| nmbas  | int     | 1                       | number of magnetic sites                       |
| nq     | int     | 1                       | number of q-points                             |
| nw     | int     | 1                       | number of frequency points                     |
| q      | real    | nq * 3                  | Cartesian q-points, in units of $$2\pi/a$$     |
| realw  | real    | nw                      | frequencies ω, in Ryd                          |
| u      | real    | nw * nmbas              | RSA interaction for each magnetic site, in Ryd |

