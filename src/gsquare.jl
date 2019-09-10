function gsquare(table,mval)
   sumval = 0.0
   for pos in eachindex(table)
      if table[pos] > 0
         sumval += table[pos]*log(table[pos]/mval[pos])
      end
   end
   2*sumval
end
