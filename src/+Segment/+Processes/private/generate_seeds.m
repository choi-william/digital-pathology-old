function returnBlock = generate_seeds(block_struct) 
    imageData = block_struct.data;
    mask = imageData(:,:,1);
    originalImage = imageData(:,:,2);
    returnBlock = zeros(size(mask));
    if sum(sum(mask)) > 0
        minVal = min(originalImage(:));
        [row, col] = find(originalImage == minVal, 1);
        returnBlock(row,col) = 1;
    end
end