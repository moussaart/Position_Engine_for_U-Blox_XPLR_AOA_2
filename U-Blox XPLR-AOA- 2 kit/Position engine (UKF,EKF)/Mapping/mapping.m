function Data=mapping(courbe_type,ref_points,a,b,X_center,Y_center,n)
    switch courbe_type
        case "Ellipse"
              XY = generateEllipse(a,b,X_center,Y_center,n);
              Data = inv_Triangulation(XY(:,1), XY(:,2), ref_points);
        case "Square"
            XY = generateSquare(a,b,X_center,Y_center,n);
            Data = inv_Triangulation(XY(:,1), XY(:,2), ref_points);
        case "Triangle"
            XY=generateTriangle(a,X_center,Y_center,n);
            Data = inv_Triangulation(XY(:,1), XY(:,2), ref_points);
            
        case "Hexagonal"
            XY = generateHexagon(a,X_center,Y_center,n);
            Data = inv_Triangulation(XY(:,1), XY(:,2), ref_points);
    end
end