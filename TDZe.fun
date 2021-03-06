﻿%%Fonction Flatten
%Pre: Recoit une partition en argument
%Post: Renvoie la partition "etalee", soit une liste ou chaque element n'est pas une liste,
%mais bien une note ou une transformation
fun{Flatten Partition}
	local 
		fun{FlattenAux List A}
			case List of nil then A
			[] H|T then {FlattenAux H {FlattenAux T A}}
			else List|A %cas ou List n'est pas une liste et est donc un element
			end
		end
	in 
	{FlattenAux Partition nil}
	end
end

%%Fonction NoteToEchantillon
%Pre: Recoit une note (non nulle), une duree (non nulle) et un nombre de demiton (>=0).
%Une note non transformee aura par défaut 0 demitons
%Post: Renvoie un echantillon avec comme hauteur la hauteur de la note + les demitons passes en argument
% comme duree la duree passee en argument et comme instrument aucun.
fun{NoteToEchantillon Note Duree DemiTons}
	Octave Hauteur Nom I1 Ech in
	Nom=note.nom
	Octave=note.octave
		case Nom 
			of a then I1=0
			[] b then I1=2 %2demitons entre a et b
			[] c then I1=3 %2+1 demitons entre a et c
			[] d then I1=5 %3+2 demitons entre a et d
			[] e then I1=7 %5+2 demitons entre a et e
			[] f then I1=-4 %-2-2 demitons entre a et f
			[] g then I1=-2 %-2 demitons entre a et g
		end
	Hauteur= (Octave-4)*12 + I1 + DemiTons
	Ech=echantillon(hauteur:Hauteur duree:Duree instrument:none)
	end
end

%%Fonction Reverse
%Pre: Prend une partition en argument
%Post: renvoie la partition inversee. (Premier element devient le dernier)
fun {Reverse Partition}
   local fun{ReverseAux S A}
	    case S of nil then A
	    [] H|T then {ReverseAux T H|A}
	    end
	 end
   in
      {ReverseAux Partition nil}
   end
end

%%Fonction DureeTot
%Pre: recoit une partition
%Post: renvoie la duree totale de la partition
fun {DureeTot Partition}
	local 
		fun{DureeTotAux Part Acc Inc}
			case Part 
			of nil then Acc
			[] H|T then 
				case H
				of note(nom:Nom octave:Octave alteration:Alteration) then {DureeTotAux T Acc+Inc Inc}
				of muet(Partition) then {DureeTotAux T {DureeTotAux Partition Acc Inc} Inc}
				of duree(secondes:Seconde Partition) then {DureeTotAux T Acc+Seconde Inc}
				of etirer(facteur:Facteur Partition) then {DureeTotAux T {DureeTotAux Partition Acc Facteur*Inc} Inc}
				of bourdon(note:Note Partition) then {DureeTotAux T {DureeTotAux Partition Acc Inc} Inc}
				of transpose(demitons:Entier Partition) then {DureeTotAux T {DureeTotAux Partition Acc Inc} Inc}
				end
			end
		end
	in
	{DureeTot Partition 0.0 1.0}
	end
end
