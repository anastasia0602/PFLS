FASTA_FILE=$1

num_sequences=$(grep -c ">" "$FASTA_FILE")
seq_length=$(grep -v ">" "$FASTA_FILE" | paste -sd "" - | awk '{print length}')
total_length=$(echo "$seq_length" | awk '{sum+=$1} END {print sum}')
longest_seq=$(echo "$seq_length" | sort -n | head -1)
shortest_seq=$(echo "$seq_length" | sort -nr | head -1)
avg_length=$(awk "BEGIN {print $total_length/$num_sequences}")
gc_percent=$()
 


echo "FASTA File Statistics:"
echo "----------------------"
echo "Number of sequences: $num_sequences"
echo "Total length of sequences: $total_length"
echo "Length of the longest sequence: $longest_seq"
echo "Length of the shortest sequence: $shortest_seq"
echo "Average sequence length: $avg_length"
echo "GC Content (%): $gc_percent"
