															  ***TD de Micro�conom�trie mag 3***
							        ***Chapitre 4-): Les mod�les � variables qualitatives polytomiques en coupe transversale***
								

									***Section 1-): Les mod�les � variables qualitatives polytomiques ordonn�es en coupe transversale***
										   ***Application � l'�tude des d�terminants socio-�conomiques des r�gimes d�mocratiques***
										   									   
*Ouverture de la base de donn�es:

clear all
cd""
use ChapIVa_Microeconometrie_mag3.dta										   
set more off
										 										   
*I-)Cr�ation de la variable polytomique ordonn�e de r�gimes politiques:

*Rappel:
*La variable d�mocratie est cod�e 0 si la variable polity2 appartient � l'intervalle [-10;-6] = dictatures
*La variable d�mocratie est cod�e 1 si la variable polity2 appartient � l'intervalle [-5;+5] = r�gimes mixtes
*La variable d�mocratie est cod�e 2 si la variable polity2 appartient � l'intervalle [+6;+10] = d�mocraties


generate democratie=0 if polity2>=-10 & polity2<=-6 & polity2!=.
replace democratie=1 if polity2>=-5 & polity2<=5
replace democratie=2 if polity2>=6 & polity2<=10
replace democratie=. if polity2==.
list cname polity2 democratie

*II-)Analyse pr�alable des variables prises en compte lors de l'analyse �conom�trique:

	*a-)Application de la commande describe:

describe democratie polity2 lrgdpch educprim_H_F pop oil_rents urban

	*b-)Application de la commande summarize:

summarize democratie polity2 lrgdpch educprim_H_F pop oil_rents urban
summarize democratie, detail
summarize polity2, detail

	*c-)Application de la commande tabulate aux variables d�mocratie et polity2:

tabulate democratie
tabulate polity2

*II-)Analyse �conom�trique de base:

	*a-)MCO (mod�le de probabilit� lin�aire):

reg democratie lrgdpch educprim_H_F pop oil_rent urban
estat ic
estimates store MPL 

	*b-)MCO (mod�le de probabilit� lin�aire)avec l'option robuste (prise en compte de l'h�t�rosc�dasticit� des erreurs):

reg democratie lrgdpch educprim_H_F pop oil_rents urban , ro
estat ic
estimates store MPL_r

	*c-)Mod�le Probit ordonn�:

oprobit democratie lrgdpch educprim_H_F pop oil_rents urban 
estat ic
estimates store OProbit

	*Calcul des effets marginaux (�valu�s au point moyen) associ�s aux trois modalit�s de la variable d�mocratie:
	
mfx, predict(outcome(0)) at(mean)
mfx, predict(outcome(1)) at(mean)
mfx, predict(outcome(2)) at(mean)

	*d-)Mod�le Probit ordonn� avec �carts-types robustes:

oprobit democratie lrgdpch educprim_H_F pop oil_rents urban, vce(robust)
estat ic
estimates store OProbit_r

	*Calcul des effets marginaux (�valu�s au point moyen) associ�s aux trois modalit�s de la variable d�mocratie:
	
mfx, predict(outcome(0)) at(mean)
mfx, predict(outcome(1)) at(mean)
mfx, predict(outcome(2)) at(mean)


	*e-)Mod�le Logit ordonn�:

ologit democratie lrgdpch educprim_H_F pop oil_rents urban 
estat ic
estimates store OLogit

	*Calcul des effets marginaux (�valu�s au point moyen) associ�s aux trois modalit�s de la variable d�mocratie:
	
mfx, predict(outcome(0)) at(mean)
mfx, predict(outcome(1)) at(mean)
mfx, predict(outcome(2)) at(mean)

	*f-)Mod�le Logit ordonn� avec �carts-types robustes:

ologit democratie lrgdpch educprim_H_F pop oil_rents urban, vce(robust)
estat ic
estimates store OLogit_r

	*Calcul des effets marginaux (�valu�s au point moyen) associ�s aux trois modalit�s de la variable d�mocratie:
	
mfx, predict(outcome(0)) at(mean)
mfx, predict(outcome(1)) at(mean)
mfx, predict(outcome(2)) at(mean)

	*g-)Tableaux de synth�se des r�sultats obtenus:

estimates table MPL MPL_r OProbit OProbit_r OLogit OLogit_r, se stats(N r2 r2_a ll aic)
estimates table MPL MPL_r OProbit OProbit_r OLogit OLogit_r, star(0.10 0.05 0.01) stats(N r2 r2_a ll aic)

*On conserva le mod�le Logit ordonn� avec �carts-types robustes pour l'analyse du pouvoir explicatif du mod�le � l'aide d'un tableau de contingence .

	*i-)Comparaison des pr�diction associ�es aux six mod�les pr�c�dement estim�s:

*MCO:

quietly reg democratie lrgdpch educprim_H_F pop oil_rent urban
predict p_mpl, xb

*MCO avec �carts-types robustes:

quietly reg democratie lrgdpch educprim_H_F pop oil_rents urban, ro
predict p_mpl_r, xb

*Probit ordonn�:

quietly oprobit democratie lrgdpch educprim_H_F pop oil_rents urban
predict p0_oprobit p1_oprobit p2_oprobit, pr

*Probit ordonn� avec �carts-types robustes:

quietly oprobit democratie lrgdpch educprim_H_F pop oil_rents urban, vce(robust)
predict p0_oprobit_r p1_oprobit_r p2_oprobit_r, pr

*Logit ordonn�:

quietly ologit democratie lrgdpch educprim_H_F pop oil_rents urban 
predict p0_ologit p1_ologit p2_ologit, pr

*Logit ordonn� avec �carts-types robustes:

quietly ologit democratie lrgdpch educprim_H_F pop oil_rents urban, vce(robust)
predict p0_ologit_r p1_ologit_r p2_ologit_r, pr

*Synth�se des r�sultats obtenus:

summarize democratie p_mpl p_mpl_r p0_oprobit p1_oprobit p2_oprobit p0_oprobit_r p1_oprobit_r p2_oprobit_r ///
p0_ologit p1_ologit p2_ologit p0_ologit_r p1_ologit_r p2_ologit_r


 *III-)Evaluation de la qualit� du mod�le:

*Nous conservons le mod�le Logit ordonn� avec �carts-types robustes (log-vraisemblance et aic)

	*a-)Tableau de contingence (qualit� des pr�visions du mod�le):
	
	*Cr�ation de la variable polytomique de r�gimes politiques issue du calcul des probabilit�s pr�dites:
	
generate democratie_pred=0 if p0_ologit_r>p1_ologit_r&p0_ologit_r>p2_ologit_r
replace democratie_pred=1 if p1_ologit_r>p0_ologit_r&p1_ologit_r>p2_ologit_r
replace democratie_pred=2 if p2_ologit_r>p1_ologit_r&p2_ologit_r>p0_ologit_r

list cname democratie democratie_pred

	*D�termination du tableau crois� entre valeurs pr�dites et valeurs effectives de la variable d�pendante:
	
tabulate democratie_pred democratie

	*Calcul du taux de bonne r�ponse:
	
display [17+51]/89
*0.76

*Dans 76% des cas notre mod�le pr�dit la bonne forme de r�gime politique.



									***Section 2-): Les mod�les � variables qualitatives polytomiques non ordonn�es en coupe transversale***
							  ***Application � l'�tude des d�terminants du type de formation professionnelle re�u dans le cadre du programme JTPA***
							  
							  
*Ouverture de la base de donn�es:

clear all
cd""
use ChapIVb_Microeconometrie_mag3.dta
set more off

*Informations relatives � la base de donn�es:

*Cette base de donn�es consiste en un �chantillon al�atoire de 1500 femmes adultes d'age superieur � 21 ans ayant particip�es au Job Training Partnership Act (JTPA).
*Il s'agit du plus vaste programme de formation professionnelle mis en oeuvre aux Etats-Unis entre la fin des ann�es 1980 et le d�but des ann�es 1990.
*La variable d�pendante de formation professionnelle est compos�e des quatre modalit�s suivantes:

*=> 1 = Classroom training in occupational skills (CT).
*=> 2 = Subsidized on-the-job training at private firms (OJT).
*=> 3 = Job search assistance (JSA).
*=> 4 = Other.

							  
*I-)Analyse pr�alable des variables prises en compte lors de l'analyse �conom�trique:

	*a-)Application de la commande describe:

describe stype age ed1 ed2 ed3 black hisp nvrwrk 

	*b-)Application de la commande summarize:

summarize stype age ed1 ed2 ed3 black hisp nvrwrk 
summarize stype , detail

	*c-)Application de la commande tabulate � la variable stype:

tabulate stype

*II-)Le mod�le Logit_multinomial:

	*1-)Estimation du mod�le:
							  
mlogit stype black hisp age ed2 ed3 nvrwrk, baseoutcome(4)
estat ic
estimates store Multinomial_logit

*Note: La modalit� 4 est consid�r�e comme modalit� de r�f�rence.

	*2-)Calcul des probabilit�s pr�dites associ�es � chacune des modalit�s de la variable d�pendante:
	
predict p1_mlogit p2_mlogit p3_mlogit p4_mlogit, pr
summarize p1_mlogit p2_mlogit p3_mlogit p4_mlogit

	*3-)Calcul des effets marginaux associ�s � chacune des modalit�s de la variable d�pendante:
	
mfx, predict(pr outcome(1))
mfx, predict(pr outcome(2))
mfx, predict(pr outcome(3))
mfx, predict(pr outcome(4))

	*4-)Interpr�tation des r�sultats en termes de ratio de risque relatif:
	
mlogit stype black hisp age ed2 ed3 nvrwrk, rrr baseoutcome(4)

	*5-)Evaluation de la validit� de l'hypoth�se IIA:

	*Suppression de la modalit� 2:
	
		*Estimation du mod�le Logit multinomial de base (avec toutes les modalit�s de la variable d�pendante):
	
quietly mlogit stype black hisp age ed2 ed3 nvrwrk, baseoutcome(4)
estimates store base_mlogit

		*R�estimation du mod�le Logit multinomial en supprimant la modalit� 2 de la variable d�pendante:
	
quietly mlogit stype black hisp age ed2 ed3 nvrwrk if stype!=2, baseoutcome(4)
estimates store partiel2_mlogit

		*Comparaison des coefficients associ�s � ces deux mod�les � l'aide du test d'Hausman:
	
hausman partiel2_mlogit base_mlogit, alleqs constant
	
*L'hypoth�se IIA est v�rifi�e lorsque l'on supprime la modalit� 2.

	*Suppression de la modalit� 3: 
	
		*Estimation du mod�le Logit multinomial de base (avec toutes les modalit�s de la variable d�pendante):
	
quietly mlogit stype black hisp age ed2 ed3 nvrwrk, baseoutcome(4)
*estimates store base_mlogit

		*R�estimation du mod�le Logit multinomial en supprimant la modalit� 3 de la variable d�pendante:
	
quietly mlogit stype black hisp age ed2 ed3 nvrwrk if stype!=3, baseoutcome(4)
estimates store partiel3_mlogit

		*Comparaison des coefficients associ�s � ces deux mod�les � l'aide du test d'Hausman:
	
hausman partiel3_mlogit base_mlogit, alleqs constant
	
*L'hypoth�se IIA est v�rifi�e lorsque l'on supprime la modalit� 3.
							  
	*Suppression de la modalit� 1: 
	
		*Estimation du mod�le Logit multinomial de base (avec toutes les modalit�s de la variable d�pendante):
	
quietly mlogit stype black hisp age ed2 ed3 nvrwrk, baseoutcome(4)
*estimates store base_mlogit

		*R�estimation du mod�le Logit multinomial en supprimant la modalit� 1 de la variable d�pendante:
	
quietly mlogit stype black hisp age ed2 ed3 nvrwrk if stype!=1, baseoutcome(4)
estimates store partiel1_mlogit

		*Comparaison des coefficients associ�s � ces deux mod�les � l'aide du test d'Hausman:
	
hausman partiel1_mlogit base_mlogit, alleqs constant
	
*Etant donn� le grand nombre d'observations supprim�es, il n'est pas possible d'obtenir les propri�t�s asymptotiques n�cessaires � la validit� du test d'Hausman.
*Cependant, dans la mesure ou le diff�rentiel de coefficient est sensiblement plus important que dans les cas pr�c�dents (suppression des modalit�s 2 et 3), 
*nous allons par pr�caution faire l'hypoth�se que la suppression de la modalit� 1 conduit au rejet de l'hypoth�se IIA.	
							  
	*III-)Les mod�les Mixed Logit, Nested Logit et Probit multinomial:
	
	*1-)Transformation pr�alable de la base de donn�es au format long:

	*a-)Cr�ation de variables binaires indicatrices des modalit�s prises par la variable stype:
	
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

*Note: Une variable schoice a �t� cr�e listant pour chaque individu les modalit�s possibles de la variable d�pendante.
*Une variable serv a �t� cr�e (nouvelle variable d�pendante de nos mod�les Mixed Logit, Nested Logit et Probit multinomial).
*Cette derni�re est une variable binaire caract�risant la modalit� effectivement choisit par chaque individu.

*Donc:

*=> stype = variable polytomique indiquant la modalit� effectivement choisit par chaque individu.
*=> serv =  variable binaire indiquant la modalit� effectivement choisit par chaque individu.
*=> schoice = variable indiquant l'ensemble des modalit�s possibles.

	*2-)Mise en relation de la commande mlogit (Logit multinomial) et de la commande asclogit (mod�le de type Mixed Logit):
	
summarize serv schoice stype
list serv schoice stype

	*a-)Estimation du mod�le:
	
asclogit serv, case(bifid) alternatives(schoice) casevars(black hisp age ed2 ed3 nvrwrk) basealternative(4)
estat ic
estimates store Mixed_logit

	*b-)Calcul des probabilit�s pr�dites:

predict pasclogit, pr
table schoice, contents(mean serv mean pasclogit)

	*c-)Calcul des effets marginaux:
	
estat mfx, varlist(black hisp age ed2 ed3 nvrwrk)

	*3-)Le mod�le Nested Logit:
	
	*a-)Cr�ation des groupes de modalit�s:
	
nlogitgen program = schoice(training:1|2, assistance:3|4)

*Note: 
*=>Cr�ation d'une variable caract�risant les diff�rents groupes de modalit�s cr�es = program.
*=>Cr�ation d'un premier groupe de modalit�s "training" regroupant les modalit�s CT et OJT.
*=>Cr�ation d'un second groupe de modalit�s "assistance" regroupant les modalit�s JSA et Other.

	*b-)V�rification des groupes de modalit�s cr�es:
	
nlogittree schoice program, choice(serv)

*Note: l'option choice(serv) permet d'obtenir les fr�quences observ�es au sein de l'�chantillon de chaque modalit� de la variable d�pendante.

	*c-)Estimation du mod�le Nested Logit:
	
nlogit serv || program:, base(assistance) || schoice: black hisp age ed2 ed3, base(4) case(bifid)
estat ic
estimates store Nested_logit

*ATTENTION: suppression de la variable nvrwrk afin de que le mod�le puisse converger vers une solution.
	
	*4-)Le mod�le Probit multinomial:
	
	*a-)Estimation du mod�le Probit multinomial:
	
asmprobit serv, casevars(black hisp age ed2 ed3) case(bifid) alternatives(schoice) basealternative(4) 
estat ic
estimates store Multinomial_probit
							  
	*b-)Obtention de la matrice de variance-covariance estim�e des erreurs du mod�le:
	
estat covariance 

	*c-)Obtention de la matrice de corr�lation associ�e � la matrice de variance-covariance estim�e des erreurs:
	
estat correlation

	*d-)Calcul des effets marginaux:

estat mfx
					
	*5-)Synth�se des r�sultats obtenus:
	
estimates table Multinomial_logit Mixed_logit Nested_logit, se stats(N ll aic)	
estimates table Multinomial_logit Mixed_logit Nested_logit, star(0.10 0.05 0.01) stats(N ll aic)

							  
							  
							  
							  
							  
							  
							  
							  
							  
