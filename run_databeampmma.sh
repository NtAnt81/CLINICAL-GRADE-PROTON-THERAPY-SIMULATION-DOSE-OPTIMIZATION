#!/bin/bash

# ===============================================================
# DATA MASTER (Paste masing-masing kolom data Anda di dalam kurung)
# ===============================================================

# 1. Kolom Energi (MeV)
ENERGIES=(
150.000000
149.044962
148.396135
147.745115
147.091879
146.436402
145.778657
145.118620
144.456263
143.791559
143.124480
142.454999
141.783086
141.108713
140.431848
139.752463
139.070524
138.386001
137.698861
137.009070
136.316595
135.621400
134.923451
134.222710
133.519141
132.812706
132.103365
131.391080
130.675808
129.957510
129.236141
128.511658
127.784016
127.053170
126.319073
)

# 2. Kolom Bobot / Jumlah Partikel
WEIGHTS=(
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
100000
)

# 3. Kolom Position Spread (mm)
POS_SPREADS=(
3.722
3.728
3.733
3.737
3.742
3.746
3.751
3.756
3.761
3.766
3.770
3.775
3.780
3.786
3.791
3.796
3.801
3.806
3.812
3.817
3.823
3.829
3.834
3.840
3.846
3.852
3.858
3.864
3.870
3.876
3.883
3.889
3.895
3.902
3.909
)

# 4. Kolom Angular Spread (mrad)
ANG_SPREADS=(
4.08
4.10
4.12
4.14
4.15
4.17
4.19
4.21
4.22
4.24
4.26
4.28
4.30
4.32
4.34
4.36
4.38
4.40
4.42
4.44
4.46
4.48
4.50
4.53
4.55
4.57
4.59
4.62
4.64
4.67
4.69
4.71
4.74
4.77
4.79
)

# ===============================================================
# PROSES KOMPILASI DATA KE TEMPLATE
# ===============================================================

NUM_LAYERS=${#ENERGIES[@]}
TIMES_STR=""
ENERGIES_STR=""
WEIGHTS_STR=""
POS_STR=""
ANG_STR=""

echo "Mengekstrak array Time Features untuk $NUM_LAYERS lapisan energi..."

# Validasi sederhana untuk memastikan jumlah baris semua kolom sama
if [ ${#WEIGHTS[@]} -ne $NUM_LAYERS ] || [ ${#POS_SPREADS[@]} -ne $NUM_LAYERS ] || [ ${#ANG_SPREADS[@]} -ne $NUM_LAYERS ]; then
    echo "[ERROR] Jumlah baris data pada Energi, Bobot, Pos, dan Ang tidak sama! Harap periksa kembali hasil copy-paste Anda."
    exit 1
fi

# Looping menyatukan variabel berdasarkan urutan barisnya
for i in "${!ENERGIES[@]}"; do
    waktu=$((i + 1)).0
    
    TIMES_STR="$TIMES_STR $waktu"
    ENERGIES_STR="$ENERGIES_STR ${ENERGIES[$i]}"
    WEIGHTS_STR="$WEIGHTS_STR ${WEIGHTS[$i]}"
    POS_STR="$POS_STR ${POS_SPREADS[$i]}"
    ANG_STR="$ANG_STR ${ANG_SPREADS[$i]}"
done

echo "Menyuntikkan susunan data ke dalam SOBP_TEMPLATE.txt..."

sed -e "s/NUMLAYERS/$NUM_LAYERS/g" \
    -e "s/TIME_ARRAY/$TIMES_STR/g" \
    -e "s/ENERGY_ARRAY/$ENERGIES_STR/g" \
    -e "s/WEIGHT_ARRAY/$WEIGHTS_STR/g" \
    -e "s/POS_ARRAY/$POS_STR/g" \
    -e "s/ANG_ARRAY/$ANG_STR/g" \
    SOBP_TEMPLATE.txt > SIMULASI_SOBP_FINAL.txt

echo "==========================================================="
echo "Konfigurasi Selesai! Memulai Simulasi TOPAS (Active Scanning)"
echo "==========================================================="

~/topas/bin/topas SIMULASI_SOBP_FINAL.txt

echo "==========================================================="
echo "Simulasi Selesai! Hasil dosis tersimpan di 'SOBP_Target_Dose.csv'."
