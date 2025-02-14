mkdir -p "COMBINED-DATA"
cd RAW-DATA

for directory in D*/; do
    trans=$(grep "^${directory%/}" sample-translation.txt || echo "MISSING_TRANSLATION")
    if [[ "$trans" == "MISSING_TRANSLATION" ]]; then
        echo "WARNING: No translation found for directory $directory"
        continue
    fi

    name=$(echo "$trans" | awk '{print $2}')
    cp "${directory}checkm.txt" "../COMBINED-DATA/${name}-CHECKM.txt"
    cp "${directory}gtdb.gtdbtk.tax" "../COMBINED-DATA/${name}-GTDB-TAX.txt"
    cp "${directory}bins/bin-unbinned.fasta" "../COMBINED-DATA/${name}_UNBINNED.fa"

    completeness=$(awk 'NR>=3 {if (NF >= 13) print $13}' "${directory}checkm.txt" | tr -s '\n' ' ')
    contamination=$(awk 'NR>=3 {if (NF >= 14) print $14}' "${directory}checkm.txt" | tr -s '\n' ' ')

    bins=1
    mags=1

    for i in $(seq 1 $(echo "$completeness" | wc -w)); do
        comp=$(echo "$completeness" | cut -d' ' -f$i)
        cont=$(echo "$contamination" | cut -d' ' -f$i)

            if (( $(echo "$comp > 50.00" | bc -l) )) && (( $(echo "$cont < 5.00" | bc -l) )); then
                class="MAG"
                new_file_name="${name}_MAG_$(printf "%03d" $mags).fa"
                mags=$((mags + 1))
            elif (( $(echo "$cont < 5.00" | bc -l) )); then
                class="BIN"
                new_file_name="${name}_BIN_$(printf "%03d" $bins).fa"
                bins=$((bins + 1))
            fi
            cp "${directory}bins/bin-unbinned.fasta" "../COMBINED-DATA/${new_file_name}"
    done

    for fasta in "${directory}bins/"*; do
        file_name="${fasta#${directory}bins/}"
        if [[ "$file_name" =~ ^bin-[0-9].* ]]; then
            current_dna=$(basename "$directory")
            current_number=$(echo "$current_dna" | sed 's/[^0-9]*//g')
            next_number=$((current_number + 1))
            next_dna_dir=$(echo "$directory" | sed "s/$current_dna/DNA$next_number/")
            target_dir="../EXC-004/RAW-DATA/$next_dna_dir/bins"
            mkdir -p "$target_dir"
            new_file_name="$target_dir/${class}-${file_name}"
            mv "$fasta" "$new_file_name"
        fi
    done
done


