															  ***TD de Microéconométrie mag 3***
							        ***Chapitre 4-): Les modèles à variables qualitatives polytomiques en coupe transversale***
								

									***Section 1-): Les modèles à variables qualitatives polytomiques ordonnées en coupe transversale***
										   ***Application à l'étude des déterminants socio-économiques des régimes démocratiques***
										   									   
*Ouverture de la base de données:

clear all
cd""
use ChapIVa_Microeconometrie_mag3.dta										   
set more off
										 										   
*I-)Création de la variable polytomique ordonnée de régimes politiques:

*Rappel:
*La variable démocratie est codée 0 si la variable polity2 appartient à l'intervalle [-10;-6] = dictatures
*La variable démocratie est codée 1 si la variable polity2 appartient à l'intervalle [-5;+5] = régimes mixtes
*La variable démocratie est codée 2 si la variable polity2 appartient à l'intervalle [+6;+10] = démocraties


generate democratie=0 if polity2>=-10 & polity2<=-6 & polity2!=.
replace democratie=1 if polity2>=-5 & polity2<=5
replace democratie=2 if polity2>=6 & polity2<=10
replace democratie=. if polity2==.
list cname polity2 democratie

*II-)Analyse préalable des variables prises en compte lors de l'analyse économétrique:

	*a-)Application de la commande describe:

describe democratie polity2 lrgdpch educprim_H_F pop oil_rents urban

	*b-)Application de la commande summarize:

summarize democratie polity2 lrgdpch educprim_H_F pop oil_rents urban
summarize democratie, detail
summarize polity2, detail

	*c-)Application de la commande tabulate aux variables démocratie et polity2:

tabulate democratie
tabulate polity2

*II-)Analyse économétrique de base:

	*a-)MCO (modèle de probabilité linéaire):

reg democratie lrgdpch educprim_H_F pop oil_rent urban
estat ic
estimates store MPL 

	*b-)MCO (modèle de probabilité linéaire)avec l'option robuste (prise en compte de l'hétéroscédasticité des erreurs):

reg democratie lrgdpch educprim_H_F pop oil_rents urban , ro
estat ic
estimates store MPL_r

	*c-)Modèle Probit ordonné:

oprobit democratie lrgdpch educprim_H_F pop oil_rents urban 
estat ic
estimates store OProbit

	*Calcul des effets marginaux (évalués au point moyen) associés aux trois modalités de la variable démocratie:
	
mfx, predict(outcome(0)) at(mean)
mfx, predict(outcome(1)) at(mean)
mfx, predict(outcome(2)) at(mean)

	*d-)Modèle Probit ordonné avec écarts-types robustes:

oprobit democratie lrgdpch educprim_H_F pop oil_rents urban, vce(robust)
estat ic
estimates store OProbit_r

	*Calcul des effets marginaux (évalués au point moyen) associés aux trois modalités de la variable démocratie:
	
mfx, predict(outcome(0)) at(mean)
mfx, predict(outcome(1)) at(mean)
mfx, predict(outcome(2)) at(mean)


	*e-)Modèle Logit ordonné:

ologit democratie lrgdpch educprim_H_F pop oil_rents urban 
estat ic
estimates store OLogit

	*Calcul des effets marginaux (évalués au point moyen) associés aux trois modalités de la variable démocratie:
	
mfx, predict(outcome(0)) at(mean)
mfx, predict(outcome(1)) at(mean)
mfx, predict(outcome(2)) at(mean)

	*f-)Modèle Logit ordonné avec écarts-types robustes:

ologit democratie lrgdpch educprim_H_F pop oil_rents urban, vce(robust)
estat ic
estimates store OLogit_r

	*Calcul des effets marginaux (évalués au point moyen) associés aux trois modalités de la variable démocratie:
	
mfx, predict(outcome(0)) at(mean)
mfx, predict(outcome(1)) at(mean)
mfx, predict(outcome(2)) at(mean)

	*g-)Tableaux de synthèse des résultats obtenus:

estimates table MPL MPL_r OProbit OProbit_r OLogit OLogit_r, se stats(N r2 r2_a ll aic)
estimates table MPL MPL_r OProbit OProbit_r OLogit OLogit_r, star(0.10 0.05 0.01) stats(N r2 r2_a ll aic)

*On conserva le modèle Logit ordonné avec écarts-types robustes pour l'analyse du pouvoir explicatif du modèle à l'aide d'un tableau de contingence .

	*i-)Comparaison des prédiction associées aux six modèles précédement estimés:

*MCO:

quietly reg democratie lrgdpch educprim_H_F pop oil_rent urban
predict p_mpl, xb

*MCO avec écarts-types robustes:

quietly reg democratie lrgdpch educprim_H_F pop oil_rents urban, ro
predict p_mpl_r, xb

*Probit ordonné:

quietly oprobit democratie lrgdpch educprim_H_F pop oil_rents urban
predict p0_oprobit p1_oprobit p2_oprobit, pr

*Probit ordonné avec écarts-types robustes:

quietly oprobit democratie lrgdpch educprim_H_F pop oil_rents urban, vce(robust)
predict p0_oprobit_r p1_oprobit_r p2_oprobit_r, pr

*Logit ordonné:

quietly ologit democratie lrgdpch educprim_H_F pop oil_rents urban 
predict p0_ologit p1_ologit p2_ologit, pr

*Logit ordonné avec écarts-types robustes:

quietly ologit democratie lrgdpch educprim_H_F pop oil_rents urban, vce(robust)
predict p0_ologit_r p1_ologit_r p2_ologit_r, pr

*Synthèse des résultats obtenus:

summarize democratie p_mpl p_mpl_r p0_oprobit p1_oprobit p2_oprobit p0_oprobit_r p1_oprobit_r p2_oprobit_r ///
p0_ologit p1_ologit p2_ologit p0_ologit_r p1_ologit_r p2_ologit_r


 *III-)Evaluation de la qualité du modèle:

*Nous conservons le modèle Logit ordonné avec écarts-types robustes (log-vraisemblance et aic)

	*a-)Tableau de contingence (qualité des prévisions du modèle):
	
	*Création de la variable polytomique de régimes politiques issue du calcul des probabilités prédites:
	
generate democratie_pred=0 if p0_ologit_r>p1_ologit_r&p0_ologit_r>p2_ologit_r
replace democratie_pred=1 if p1_ologit_r>p0_ologit_r&p1_ologit_r>p2_ologit_r
replace democratie_pred=2 if p2_ologit_r>p1_ologit_r&p2_ologit_r>p0_ologit_r

list cname democratie democratie_pred

	*Détermination du tableau croisé entre valeurs prédites et valeurs effectives de la variable dépendante:
	
tabulate democratie_pred democratie

	*Calcul du taux de bonne réponse:
	
display [17+51]/89
*0.76

*Dans 76% des cas notre modèle prédit la bonne forme de régime politique.



									***Section 2-): Les modèles à variables qualitatives polytomiques non ordonnées en coupe transversale***
							  ***Application à l'étude des déterminants du type de formation professionnelle reçu dans le cadre du programme JTPA***
							  
							  
*Ouverture de la base de données:

clear all
cd""
use ChapIVb_Microeconometrie_mag3.dta
set more off

*Informations relatives à la base de données:

*Cette base de données consiste en un échantillon aléatoire de 1500 femmes adultes d'age superieur à 21 ans ayant participées au Job Training Partnership Act (JTPA).
*Il s'agit du plus vaste programme de formation professionnelle mis en oeuvre aux Etats-Unis entre la fin des années 1980 et le début des années 1990.
*La variable dépendante de formation professionnelle est composée des quatre modalités suivantes:

*=> 1 = Classroom training in occupational skills (CT).
*=> 2 = Subsidized on-the-job training at private firms (OJT).
*=> 3 = Job search assistance (JSA).
*=> 4 = Other.

							  
*I-)Analyse préalable des variables prises en compte lors de l'analyse économétrique:

	*a-)Application de la commande describe:

describe stype age ed1 ed2 ed3 black hisp nvrwrk 

	*b-)Application de la commande summarize:

summarize stype age ed1 ed2 ed3 black hisp nvrwrk 
summarize stype , detail

	*c-)Application de la commande tabulate à la variable stype:

tabulate stype

*II-)Le modèle Logit_multinomial:

	*1-)Estimation du modèle:
							  
mlogit stype black hisp age ed2 ed3 nvrwrk, baseoutcome(4)
estat ic
estimates store Multinomial_logit

*Note: La modalité 4 est considérée comme modalité de référence.

	*2-)Calcul des probabilités prédites associées à chacune des modalités de la variable dépendante:
	
predict p1_mlogit p2_mlogit p3_mlogit p4_mlogit, pr
summarize p1_mlogit p2_mlogit p3_mlogit p4_mlogit

	*3-)Calcul des effets marginaux associés à chacune des modalités de la variable dépendante:
	
mfx, predict(pr outcome(1))
mfx, predict(pr outcome(2))
mfx, predict(pr outcome(3))
mfx, predict(pr outcome(4))

	*4-)Interprétation des résultats en termes de ratio de risque relatif:
	
mlogit stype black hisp age ed2 ed3 nvrwrk, rrr baseoutcome(4)

	*5-)Evaluation de la validité de l'hypothèse IIA:

	*Suppression de la modalité 2:
	
		*Estimation du modèle Logit multinomial de base (avec toutes les modalités de la variable dépendante):
	
quietly mlogit stype black hisp age ed2 ed3 nvrwrk, baseoutcome(4)
estimates store base_mlogit

		*Réestimation du modèle Logit multinomial en supprimant la modalité 2 de la variable dépendante:
	
quietly mlogit stype black hisp age ed2 ed3 nvrwrk if stype!=2, baseoutcome(4)
estimates store partiel2_mlogit

		*Comparaison des coefficients associés à ces deux modèles à l'aide du test d'Hausman:
	
hausman partiel2_mlogit base_mlogit, alleqs constant
	
*L'hypothèse IIA est vérifiée lorsque l'on supprime la modalité 2.

	*Suppression de la modalité 3: 
	
		*Estimation du modèle Logit multinomial de base (avec toutes les modalités de la variable dépendante):
	
quietly mlogit stype black hisp age ed2 ed3 nvrwrk, baseoutcome(4)
*estimates store base_mlogit

		*Réestimation du modèle Logit multinomial en supprimant la modalité 3 de la variable dépendante:
	
quietly mlogit stype black hisp age ed2 ed3 nvrwrk if stype!=3, baseoutcome(4)
estimates store partiel3_mlogit

		*Comparaison des coefficients associés à ces deux modèles à l'aide du test d'Hausman:
	
hausman partiel3_mlogit base_mlogit, alleqs constant
	
*L'hypothèse IIA est vérifiée lorsque l'on supprime la modalité 3.
							  
	*Suppression de la modalité 1: 
	
		*Estimation du modèle Logit multinomial de base (avec toutes les modalités de la variable dépendante):
	
quietly mlogit stype black hisp age ed2 ed3 nvrwrk, baseoutcome(4)
*estimates store base_mlogit

		*Réestimation du modèle Logit multinomial en supprimant la modalité 1 de la variable dépendante:
	
quietly mlogit stype black hisp age ed2 ed3 nvrwrk if stype!=1, baseoutcome(4)
estimates store partiel1_mlogit

		*Comparaison des coefficients associés à ces deux modèles à l'aide du test d'Hausman:
	
hausman partiel1_mlogit base_mlogit, alleqs constant
	
*Etant donné le grand nombre d'observations supprimées, il n'est pas possible d'obtenir les propriétés asymptotiques nécessaires à la validité du test d'Hausman.
*Cependant, dans la mesure ou le différentiel de coefficient est sensiblement plus important que dans les cas précédents (suppression des modalités 2 et 3), 
*nous allons par précaution faire l'hypothèse que la suppression de la modalité 1 conduit au rejet de l'hypothèse IIA.	
							  
	*III-)Les modèles Mixed Logit, Nested Logit et Probit multinomial:
	
	*1-)Transformation préalable de la base de données au format long:

	*a-)Création de variables binaires indicatrices des modalités prises par la variable stype:
	
generate serv1=0
replace serv1=1 if stype==1

generate serv2=0
replace serv2=1 if stype==2	

generate serv3=0
replace serv3=1 if stype==3

generate serv4=0
replace serv4=1 if stype==4

	*b-)Application de la commande reshape:

reshape long serv, i(bifid) j(schoice)

*Note: Une variable schoice a été crée listant pour chaque individu les modalités possibles de la variable dépendante.
*Une variable serv a été crée (nouvelle variable dépendante de nos modèles Mixed Logit, Nested Logit et Probit multinomial).
*Cette dernière est une variable binaire caractérisant la modalité effectivement choisit par chaque individu.

*Donc:

*=> stype = variable polytomique indiquant la modalité effectivement choisit par chaque individu.
*=> serv =  variable binaire indiquant la modalité effectivement choisit par chaque individu.
*=> schoice = variable indiquant l'ensemble des modalités possibles.

	*2-)Mise en relation de la commande mlogit (Logit multinomial) et de la commande asclogit (modèle de type Mixed Logit):
	
summarize serv schoice stype
list serv schoice stype

	*a-)Estimation du modèle:
	
asclogit serv, case(bifid) alternatives(schoice) casevars(black hisp age ed2 ed3 nvrwrk) basealternative(4)
estat ic
estimates store Mixed_logit

	*b-)Calcul des probabilités prédites:

predict pasclogit, pr
table schoice, contents(mean serv mean pasclogit)

	*c-)Calcul des effets marginaux:
	
estat mfx, varlist(black hisp age ed2 ed3 nvrwrk)

	*3-)Le modèle Nested Logit:
	
	*a-)Création des groupes de modalités:
	
nlogitgen program = schoice(training:1|2, assistance:3|4)

*Note: 
*=>Création d'une variable caractérisant les différents groupes de modalités crées = program.
*=>Création d'un premier groupe de modalités "training" regroupant les modalités CT et OJT.
*=>Création d'un second groupe de modalités "assistance" regroupant les modalités JSA et Other.

	*b-)Vérification des groupes de modalités crées:
	
nlogittree schoice program, choice(serv)

*Note: l'option choice(serv) permet d'obtenir les fréquences observées au sein de l'échantillon de chaque modalité de la variable dépendante.

	*c-)Estimation du modèle Nested Logit:
	
nlogit serv || program:, base(assistance) || schoice: black hisp age ed2 ed3, base(4) case(bifid)
estat ic
estimates store Nested_logit

*ATTENTION: suppression de la variable nvrwrk afin de que le modèle puisse converger vers une solution.
	
	*4-)Le modèle Probit multinomial:
	
	*a-)Estimation du modèle Probit multinomial:
	
asmprobit serv, casevars(black hisp age ed2 ed3) case(bifid) alternatives(schoice) basealternative(4) 
estat ic
estimates store Multinomial_probit
							  
	*b-)Obtention de la matrice de variance-covariance estimée des erreurs du modèle:
	
estat covariance 

	*c-)Obtention de la matrice de corrélation associée à la matrice de variance-covariance estimée des erreurs:
	
estat correlation

	*d-)Calcul des effets marginaux:

estat mfx
					
	*5-)Synthèse des résultats obtenus:
	
estimates table Multinomial_logit Mixed_logit Nested_logit, se stats(N ll aic)	
estimates table Multinomial_logit Mixed_logit Nested_logit, star(0.10 0.05 0.01) stats(N ll aic)

							  
							  
							  
							  
							  
							  
							  
							  
							  
