#!/bin/bash

# Script to create LUTs

reset

LUT_TAG=$1
if [ -z $LUT_TAG ]; then
    echo "Did not get tag, provide tag e.g. `./makeits.sh its3` or `./makeits.sh scenario3`"
    exit 1
fi

for j in 20; do
    for i in 0 1 2 3 4; do
root -l -b << EOF
    .L DetectorK/DetectorK.cxx+
    .L lutWrite.${LUT_TAG}.cc
    TString tag = ".${LUT_TAG}";

    TString pn[5] = {"el", "mu", "pi", "ka", "pr"};
    int pc[5] = {11, 13, 211, 321, 2212};
    const float field = 0.5f;
    const float rmin = ${j}.f;
    const int i = ${i};
    const char * filename = Form("/tmp/myluts/lutCovm.%s.%.0fkG.%.0fcm%s.dat", pn[i].Data(), field*10, rmin, tag.Data());
    gSystem->Exec(Form("rm -v %s", filename));
    lutWrite_${LUT_TAG}(filename, pc[i], field, rmin);
EOF
    done
done

date
