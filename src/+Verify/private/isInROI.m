function [ res ] = isInROI( point,ROI )

    point = round(point);
    if (point(2) > size(ROI,1))
        res = 0;
        return;
    end
    if (point(1) > size(ROI,2))
        res = 0;
        return;
    end
    res = ROI(point(2),point(1));
end

