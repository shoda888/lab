function angle = getAngle(vec1, vec2)
    vec1norm = vecnorm(vec1,2, 2);
    vec2norm = vecnorm(vec2,2, 2);
    angle = acos(dot(vec1,vec2,2) ./ (vec1norm .* vec2norm));
end