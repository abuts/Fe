function view_Kuns_add_sim

[s,qr,en]=read_add_sim_Kun('Fe_add_sim_m.dat');
qx = reshape(qr(:,1),21,21,21);
qy = reshape(qr(:,2),21,21,21);
qz = reshape(qr(:,3),21,21,21);
surf(s(:,:,1,1));
surf(squeeze(s(:,1,:,1)));
surf(s(:,:,1,10));
surf(squeeze(s(:,1,:,10)));
surf(s(:,:,1,50));
surf(squeeze(s(:,1,:,50)));
surf(s(:,:,1,80));
surf(squeeze(s(:,1,:,80)));

surf(s(:,:,5,1));
surf(s(:,:,5,10));
surf(s(:,:,5,50));
surf(s(:,:,5,80));
surf(s(:,:,10,1));
surf(s(:,:,10,10));
surf(s(:,:,10,50));
surf(s(:,:,10,80));
surf(s(:,:,15,1));
surf(s(:,:,15,10));
surf(s(:,:,15,50));
surf(s(:,:,15,80));
