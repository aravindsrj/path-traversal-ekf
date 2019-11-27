function BWmod = BWmodification(BW)
[row,col] = size(BW);
testRow = round(row/2);
 for i = 1:col
     if BW(testRow,i) == 1 && BW(testRow,i+1) == 0
         colStart = i+1;
         break;
     end
 end
 
 for i = col:-1:1
     if BW(testRow,i) == 1 && BW(testRow,i-1) == 0
         colEnd = i-1;
         break;
     end
 end    
 
 testCol = round(col/2);
  for i = 1:row
     if BW(i,testCol) == 1 && BW(i+1,testCol) == 0
         rowStart = i+1;
         break;
     end
 end
 
 for i = row:-1:1
     if BW(i,testCol) == 1 && BW(i-1,testCol) == 0
         rowEnd = i-1;
         break;
     end
 end    

 BWmod = BW(rowStart:rowEnd, colStart:colEnd);
end
         
 
 