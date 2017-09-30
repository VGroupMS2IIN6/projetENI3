Function CheckDroitPlateforme {
    $request = "select count(distinct pdp.accord) accord"
    $request += " from utilisateur u"
    $request += " join ass_profil_utilisateur pu on pu.utilisateur = u.id"
    $request += " join profil pr on pr.id = pu.profil"
    $request += " join ass_profil_droit_plateforme pdp on pdp.profil = pu.profil"
    $request += " join ass_droit_plateforme dp on dp.droit = pdp.droit_plateforme"
    $request += " join plateforme pl on pl.ID = dp.plateforme"
    $request += " join droit d on dp.droit = d.ID"
    $request += " where d.nom = '$nomDroit' and pl.nom = '$nomPlateforme' and u.login = '$ADusername';"
    $result = makeRequest $request
    return $result.accord
}

Function CheckDroitParametrage {
    $request = "select count(distinct pdu.accord) accord"
    $request += " from utilisateur u"
    $request += " join ass_profil_utilisateur pu on pu.utilisateur = u.id"
    $request += " join profil p on p.id = pu.profil"
    $request += " join ass_profil_droits_utilisateurs pdu on pdu.profil = pu.profil"
    $request += " join droits_utilisateur du on du.ID = pdu.droit"
    $request += " where u.login = '$ADusername' and pu.accord = 1 and pdu.accord = 1 and du.nom = '$nomDroit';"
    $result = makeRequest $request
    return $result.accord
}