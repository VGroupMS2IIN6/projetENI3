select count(distinct u.id) from utilisateur u
join ass_profil_utilisateur pu on pu.utilisateur = u.id
join profil pr on pr.id = pu.profil
join ass_profil_droit_plateforme pdp on pdp.profil = pu.profil
join ass_droit_plateforme dp on dp.droit = pdp.droit_plateforme
join plateforme pl on pl.ID = dp.plateforme
join droit d on dp.droit = d.ID where d.nom = 'Création de comptes' and pl.nom = 'cisco' and pdp.accord = 1 and u.login = 'sartu';

select count(distinct u.id) from utilisateur u
join ass_profil_utilisateur pu on pu.utilisateur = u.id
join profil p on p.id = pu.profil
join ass_profil_droits_utilisateurs pdu on pdu.profil = pu.profil
join droits_utilisateur du on du.ID = pdu.droit where u.login = 'admin' and pu.accord = 1 and pdu.accord = 1 and (du.nom = 'paramétrage administration');

select count(distinct u.id) from utilisateur u
join ass_profil_utilisateur pu on pu.utilisateur = u.id
join profil p on p.id = pu.profil
join ass_profil_droits_utilisateurs pdu on pdu.profil = pu.profil
join droits_utilisateur du on du.ID = pdu.droit where u.login = 'sartu' and pu.accord = 1 and pdu.accord = 1 and (du.nom = 'gestion des formations' or du.nom = 'gestion des sites');

select count(distinct u.id) from utilisateur u
join ass_profil_utilisateur pu on pu.utilisateur = u.id
join profil p on p.id = pu.profil
join ass_profil_droits_utilisateurs pdu on pdu.profil = pu.profil
join droits_utilisateur du on du.ID = pdu.droit where u.login = 'sartu' and pu.accord = 1 and pdu.accord = 1 and (du.nom = 'gestion des formations' or du.nom = 'gestion des sites');

select count(distinct u.id) from utilisateur u
join ass_profil_utilisateur pu on pu.utilisateur = u.id
join profil p on p.id = pu.profil
join ass_profil_droits_utilisateurs pdu on pdu.profil = pu.profil
join droits_utilisateur du on du.ID = pdu.droit where u.login = 'sartu' and pu.accord = 1 and pdu.accord = 1 and (du.nom = 'gestion des formations' or du.nom = 'gestion des sites');