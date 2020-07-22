function adjtab!(mval,margin,adjfactor,levelvec=(Int)[])
   if (length(levelvec) < length(size(mval)))
      for i=size(mval)[length(levelvec)+1]:-1:1
         println(i)
         println(levelvec)
         adjtab!(mval,margin,adjfactor,[levelvec...,i])
      end
   else
      adjcoord = copy(levelvec)
      adjcoord[margin] .= 1
      println("main")
      println(levelvec)
      println(mval[levelvec...])
      mval[levelvec...] = mval[levelvec...] * adjfactor[adjcoord...]
   end
   println("end")
   mval
end

function ipf(table,constraints; maxdev=0.25,maxit=10)
   p = length(size(table))
   mval = fill(1.0,size(table))
   margins = map(arg -> setdiff(1:p,arg),constraints)

   converged = false

   for iter in 1:maxit
      curmaxdev = 0

      for i=1:length(constraints)
         curtab = table
         curm = mval
         if length(margins[i]) > 0
            curtab = sum(table,dims=margins[i])
            curm = sum(mval,dims=margins[i])
         end
         adjfactor = curtab ./ curm

         curdev = maximum(abs.(curtab .- curm))
         if curdev > curmaxdev
            curmaxdev = curdev
         end

         adjtab!(mval,margins[i],adjfactor)
      end

      if curmaxdev < maxdev
         converged = true
         break
      end
   end

   if !converged
		println("ipf did not converge")
   end

   mval
end
