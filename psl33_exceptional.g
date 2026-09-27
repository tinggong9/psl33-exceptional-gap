# psl33_exceptional.g
#
# Verification of the exceptional-subgroup classification for
# G = PSL(3,3) = SL(3,3): enumerates all subgroups of a point
# stabilizer P, determines the set E(P) of subgroups H < P with
# H meeting every G-conjugate of itself, classifies E(P) up to
# G-conjugacy, and verifies that each exceptional coset action
# G/H is 3-closed.
#
# Run as:  gap -q -A -b psl33_exceptional.g

# G acting on the 13 points of PG(2,3), P = stabilizer of point 1.
pts := Set(Filtered(GF(3)^3, v -> not IsZero(v)), NormedRowVector);;
G := Image(ActionHomomorphism(SL(3,3), pts, OnLines));;
P := Stabilizer(G, 1);;
Print("|G| = ", Size(G), "  |P| = ", Size(P), "\n");

# All subgroups of P, by cyclic extension.
subs := Concatenation(List(ConjugacyClassesSubgroups(
          LatticeByCyclicExtension(P)), AsList));;
Print("subgroups of P: ", Length(subs), "\n");

# |H meet H^g| is constant on the double coset HgH, so one
# representative per double coset is an exhaustive test.
IsExceptional := function(H)
  local g;
  if Size(H) = 1 or Size(H) = Size(P) then return false; fi;
  for g in List(DoubleCosets(G, H, H), Representative) do
    if IsTrivial(Intersection(H, H^g)) then return false; fi;
  od;
  return true;
end;;
exc := Filtered(subs, IsExceptional);;
Print("exceptional subgroups: ", Length(exc), "\n");
Print("order distribution: ", Collected(List(exc, Size)), "\n");

# G-conjugacy classes of the exceptional subgroups.
classes := [];;
for H in exc do
  cl := First(classes, c -> Size(c[1]) = Size(H)
                            and IsConjugate(G, c[1], H));
  if cl = fail then Add(classes, [H, 1]);
  else cl[2] := cl[2] + 1; fi;
od;
Print("classes [order, members in P]: ",
      List(classes, c -> [Size(c[1]), c[2]]), "\n");

# For x = H in Omega = G/H, the group A_x of permutations of Omega
# fixing x and preserving every G_x-orbit on Omega^2 contains the
# stabilizer of x in G^(3). Backtracking enumerates A_x; the
# transported pair coloring then filters by the G-orbits on Omega^3:
# the G-orbit of (i,j,k) is determined by D[T_i(j)][T_i(k)], where
# T_i carries i back to x and D is the G_x-orbit coloring of pairs.
ClosureStabilizer := function(H)
  local act, GG, N, stab, orb, D, ncol, rp, Ti, i, o,
        A2, A3, img, used, search, pi, ok, j, k;
  act := FactorCosetAction(G, H);
  GG := Image(act);
  N := Index(G, H);
  stab := Stabilizer(GG, 1);
  orb := OrbitsDomain(stab, Cartesian([1..N], [1..N]), OnPairs);
  D := List([1..N], i -> []);
  for i in [1..Length(orb)] do
    for o in orb[i] do D[o[1]][o[2]] := i; od;
  od;
  ncol := Length(orb);
  rp := List([1..N], i -> RepresentativeAction(GG, 1, i));
  Ti := List([1..N], i -> List([1..N], j -> j^(rp[i]^-1)));
  A2 := [];
  img := [1];
  used := BlistList([1..N], [1]);
  search := function(v)
    local w, a, good;
    if v > N then Add(A2, PermList(ShallowCopy(img))); return; fi;
    for w in [1..N] do
      if not used[w] then
        good := true;
        for a in [1..v-1] do
          if D[a][v] <> D[img[a]][w]
             or D[v][a] <> D[w][img[a]] then
            good := false; break;
          fi;
        od;
        if good then
          img[v] := w; used[w] := true;
          search(v+1);
          used[w] := false; Unbind(img[v]);
        fi;
      fi;
    od;
  end;
  search(2);
  if Length(A2) = Size(H) then
    A3 := A2;
  else
    A3 := [];
    for pi in A2 do
      ok := true;
      for i in [1..N] do
        for j in [1..N] do
          for k in [1..N] do
            if D[Ti[i][j]][Ti[i][k]]
               <> D[Ti[i^pi][j^pi]][Ti[i^pi][k^pi]] then
              ok := false; break;
            fi;
          od;
          if not ok then break; fi;
        od;
        if not ok then break; fi;
      od;
      if ok then Add(A3, pi); fi;
    od;
  fi;
  return [Size(H), N, ncol, Length(A2), Length(A3),
          Set(A3) = Set(Elements(stab))];
end;;

Print("[ |H|, |Omega|, pair colors, |A_x|, |3-closure stab|, ",
      "= image of H ]\n");
for cl in classes do
  Print(ClosureStabilizer(cl[1]), "\n");
od;
Print("total time (ms): ", Runtime(), "\n");
QUIT;
