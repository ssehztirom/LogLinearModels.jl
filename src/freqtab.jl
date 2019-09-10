function filltab!(freqval,x)
   levels1, levels2 = size(freqval)

   for i=1:size(x,1)
      curvals = Int.(x[i,:]) .+ 1
      for j=1:levels1
         for k=1:levels2
            if curvals[1] == j && curvals[2] == k
               freqval[j,k] += 1.0
               break
            end
         end
      end
   end

   freqval
end

function splittab!(tabs,curpos,x,catno)
   curtabindex = length(curpos)+1

   lastsubtab = @view(tabs[curtabindex+1][:,:,curpos...,catno[curtabindex+2]])
   lastsubtab .= tabs[curtabindex][:,:,curpos...]
   for i=1:(catno[curtabindex+2]-1)
      cursubtab = @view(tabs[curtabindex+1][:,:,curpos...,i])
      filltab!(cursubtab,@view(x[x[:,3] .== i-1,1:2]))
      lastsubtab .-= cursubtab
   end

   if (length(tabs) > curtabindex+1)
      passvars = [1,2,collect(4:size(x,2))...]
      for i=1:catno[curtabindex+2]
         splittab!(tabs,[curpos...,i],@view(x[x[:,3] .== i-1,passvars]),catno)
      end
   end

   tabs
end

function freqtab(x; fillzeros=false)
   freqtab(LevelData(x),fillzeros=fillzeros)
end

function freqtab(leveldata::LevelData; fillzeros=false)
   tabs = Vector{Any}(undef,size(leveldata.data,2)-1)
   for i=1:length(tabs)
      tabs[i] = fill(0.0,leveldata.levelno[1:(i+1)]...)
   end

   filltab!(tabs[1],leveldata.data[:,1:2])

   if length(tabs) > 1
      splittab!(tabs,[],leveldata.data,leveldata.levelno)
   end

   table = tabs[length(tabs)]

   if fillzeros
      table[table .== 0.0] .= 0.5
   end

   table
end
