# GAP verification for PSL₃(3)

This repository contains the GAP program and recorded output for the verification of Proposition `prop:psl33-E3` in the accompanying manuscript.

The program constructs $G=\operatorname{PSL}_3(3)$ in its action on the thirteen points of $\operatorname{PG}(2,3)$ and enumerates the 646 subgroups of the point stabilizer $P$. It finds the twenty-four exceptional subgroups and their six $G$-conjugacy classes, then computes $A_x$ and $(G^{(3),\Omega})_x$ for one representative of each class.

Here an exceptional subgroup is a subgroup $1<H<P$ such that $H\cap H^g\ne 1$ for every $g\in G$. For each representative, $\Omega=G/H$ and $x=H$.

## Files

- [`psl33_exceptional.g`](psl33_exceptional.g): the verification program.
- [`psl33_exceptional.out`](psl33_exceptional.out): the supplied output, recorded with GAP 4.12.1.

Both files are preserved exactly as supplied for the manuscript.

## Run the verification

With GAP installed and available as `gap`, run the following command from this directory:

```sh
gap -q -A -b psl33_exceptional.g
```

To save a fresh output file:

```sh
gap -q -A -b psl33_exceptional.g > psl33_exceptional.actual.out
```

The program terminates GAP when it finishes. It does not require any additional GAP packages. The final `total time (ms)` value depends on the machine and run; it is not part of the mathematical result.

The unchanged program was also run with GAP 4.16.0 on 27 September 2026. All output preceding the runtime line matched the supplied output exactly.

## Results

The computation gives $|G|=5616$ and $|P|=432$. The twenty-four exceptional subgroups fall into the following six $G$-conjugacy classes. “Members in $P$” counts the subgroups in the corresponding class that lie in $P$.

| Order of H | Members in P | Degree of Ω | Pair colors | Order of A_x | Order of the 3-closure stabilizer | Equals the image of H |
| ---: | ---: | ---: | ---: | ---: | ---: | :---: |
| 48 | 9 | 117 | 345 | 48 | 48 | true |
| 54 | 4 | 104 | 264 | 54 | 54 | true |
| 72 | 3 | 78 | 148 | 72 | 72 | true |
| 108 | 4 | 52 | 72 | 108 | 108 | true |
| 144 | 3 | 39 | 22 | 288 | 144 | true |
| 216 | 1 | 26 | 16 | 1944 | 216 | true |

The pair colors are the orbits of $G_x$ on $\Omega^2$. The group $A_x$ consists of the permutations of $\Omega$ that fix $x$ and preserve each of these pair colors. The program enumerates $A_x$ by backtracking and, when needed, filters its elements by preservation of the $G$-orbits on $\Omega^3$.

In each exceptional class, the stabilizer of $x$ in the 3-closure has order $|H|$ and coincides with the image of $H$. Since the coset action is transitive, this verifies that each of these six coset actions is 3-closed.

## Use in the manuscript

Keep the two supplied files alongside the LaTeX source (or adjust the listing paths). They can be included with the `listings` package:

```latex
\lstinputlisting[caption={The verification program \texttt{psl33\_exceptional.g}.},label={lst:gap}]{psl33_exceptional.g}

\lstinputlisting[language={},numbers=none,caption={Output of Listing~\ref{lst:gap}.},label={lst:gapout}]{psl33_exceptional.out}
```
