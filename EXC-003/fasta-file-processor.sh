FASTA_FILE=$1


num_sequences=$(grep -c ">" "$1")
seq_length=$(grep -v ">" "$1" | paste -sd "" - | awk '{print length}')
total_length=$(echo "$seq_length" | awk '{sum+=$1} END {print sum}')
longest_seq=$(awk '!/>/ {if (length > max) max = length} END {print max}' "$1")
shortest_seq=$(awk '!/>/ {if (min == 0 || length < min) min = length} END {print min}' "$1")
avg_length=$(awk "BEGIN {print $total_length/$num_sequences}")
gc_content=$(grep -v ">" "$1" | grep -o "[GCgc]" | wc -l)
gc_percent=$(awk "BEGIN {print ($gc_content/$total_length)*100}")


 


echo "FASTA File Statistics:"
echo "----------------------"
echo "Number of sequences: $num_sequences"
echo "Total length of sequences: $total_length"
echo "Length of the longest sequence: $longest_seq"
echo "Length of the shortest sequence: $shortest_seq"
echo "Average sequence length: $avg_length"
echo "GC Content (%): $gc_percent"
