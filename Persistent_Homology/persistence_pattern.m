function [persistence,Rips_simplex_tree]=persistence_pattern(pts)
pointcloud=py.numpy.array(pts);
Rips_complex=py.gudhi.RipsComplex(points=pointcloud);
Rips_simplex_tree=Rips_complex.create_simplex_tree(max_dimension=0);
persistence = Rips_simplex_tree.persistence();
end