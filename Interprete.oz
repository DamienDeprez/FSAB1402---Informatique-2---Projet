declare
fun {Interprete Partition}
   local Flatten NoteToEchantillon Reverse InterpreteAux DureeTot in
      fun{Flatten Partition}
	 local 
	    fun{FlattenAux List A}
	       case List of nil then A
	       [] H|T then {FlattenAux H {FlattenAux T A}}
	       else List|A end %cas ou List n'est pas une liste et est donc un élément 
	    end % fin FLattenAux List
	 in 
	    {FlattenAux Partition nil}
	 end % fin local
      end % fin fun{Flatten Partition}
	    
      fun{NoteToEchantillon Note Duree DemiTons}
	 local Octave Hauteur Nom I1 Ech in
	    case Note of note(nom:Name octave:Oct alteration:Alt) then
	       Nom=Note.nom
	       Octave=Note.octave
	       case Nom 
	       of a then I1=0
	       [] b then I1=2 % 2 demitons entre a et b
	       [] c then I1=~9 %-7-2 demitons entre a et c
	       [] d then I1=~7 %-5-2 demitons entre a et d
	       [] e then I1=~5 %-4-1 demitons entre a et e
	       [] f then I1=~4 %-2-2 demitons entre a et f
	       [] g then I1=~2 %-2 demitons entre a et g
	       end % fin case Nom
	       Hauteur= (Octave-4)*12 + I1 + DemiTons
	       echantillon(hauteur:Hauteur duree:Duree instrument:none)
	    [] silence then silence(duree:Duree)
	    end%fin du case
	 end % fin local Octave Hauteur Nom I1 Ech
      end % fin fun{NoteToEchantillon Note Duree DemiTons}

      fun {Reverse Partition}
	 local ReverseAux in
	    fun{ReverseAux S A}
	       case S of nil then A
	       [] H|T then {ReverseAux T H|A}
	       end % fin case S
	    end % fin fun{ReverseAux S A}
	    {ReverseAux Partition nil}
	 end % fin local ReverseAux
      end % fin fun {Reverse Partition}

      fun {DureeTot Partition}
	 local 
	    fun{DureeTotAux Part Acc Inc}
	       case Part 
	       of nil then Acc
	       [] H|T then 
		  case H
		  of note(nom:Nom octave:Octave alteration:Alteration) then {DureeTotAux T Acc+Inc Inc}
		  [] muet(Partition) then {DureeTotAux T {DureeTotAux {Flatten Partition} Acc Inc} Inc}
		  [] duree(secondes:Seconde Partition) then {DureeTotAux T Acc+Seconde Inc}
		  [] etirer(facteur:Facteur Partition) then {DureeTotAux T {DureeTotAux {Flatten Partition} Acc Facteur*Inc} Inc}
		  [] bourdon(note:Note Partition) then {DureeTotAux T {DureeTotAux {Flatten Partition} Acc Inc} Inc}
		  [] transpose(demitons:Entier Partition) then {DureeTotAux T {DureeTotAux {Flatten Partition} Acc Inc} Inc}
		  [] Nom#Octave then {DureeTotAux T Acc+Inc Inc}
		  [] Atom then {DureeTotAux T Acc+Inc Inc}
		  end % fin case H
	       end % fin case Part
	    end % fin fun{DureeTotAux Part Acc Inc}
	 in
	    {DureeTotAux Partition 0.0 1.0}
	 end % fin local 
      end % fin fun {DureeTot Partition}

      fun {InterpreteAux Partition Note Duree DemiTons Acc}
				%Case of Partition type
	 case Partition
	 of nil then Acc	
	 [] Nom#Octave then
	    if Note==nil then {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon note(nom:Nom octave:Octave alteration:'#') Duree DemiTons}|Acc}
	    else {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon Note Duree DemiTons}|Acc} end

	 [] note(nom:Nom octave:Octave alteration:Alteration) then
	    if Note==nil then 
	       {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon Partition Duree DemiTons}|Acc}
	    else 
	       {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon Note Duree DemiTons}|Acc} end

	 [] muet(TPartition) then 
	    {InterpreteAux TPartition silence Duree DemiTons Acc}

	 [] etirer(facteur:F TPartition) then
	    local DureeF IsFloat in
	       {Float.is Duree IsFloat}
	       if IsFloat then {InterpreteAux TPartition Note Duree*F DemiTons Acc}
	       else {Int.toFloat Duree DureeF}
		  {InterpreteAux {Flatten TPartition} Note DureeF*F DemiTons Acc} end
	    end
	 [] duree(seconde:S TPartition) then
	    local DureeTotale DureeTotF DureeIniF IsFloat in
	       DureeTotale={DureeTot {Flatten TPartition}}
	       {Float.is DureeTotale IsFloat}
	       {Int.toFloat Duree DureeIniF} %cast en float pour la division
	       if IsFloat then
		  {InterpreteAux TPartition Note DureeIniF*S/DureeTotale DemiTons Acc}
	       else
		  {Int.toFloat DureeTotale DureeTotF}
		  {InterpreteAux TPartition Note DureeIniF*S/DureeTotF DemiTons Acc} end
						
	    end % fin local TPartitionFlat DureeTot DureeF DureeIniF

	 [] bourdon(note:NoteB TPartition) then
	    case NoteB
	    of Nom#Octave then {InterpreteAux TPartition note(nom:Nom octave:Octave alteration:'#') Duree DemiTons Acc}
	    [] Atom then
	       case {AtomToString Atom}
	       of [N]  then  {InterpreteAux TPartition note(nom:Atom octave:4 alteration:none) Duree DemiTons Acc}
		  [] [N O] then  {InterpreteAux TPartition note(nom:{StringToAtom [N]} octave:{StringToInt [O]} alteration:'#') Duree DemiTons Acc}
	       end
	    end
	    
	 [] transpose(demitons:DemiTons TPartition) then
	    {InterpreteAux TPartition Note Duree DemiTons Acc}

	 [] H|T then
	    {InterpreteAux T Note Duree DemiTons {InterpreteAux H Note Duree DemiTons Acc}}

	 [] Atom then
	    case {AtomToString Atom}
	    of [N] then
	       if Note==nil then {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon note(nom:Atom octave:4 alteration:none) Duree DemiTons}|Acc}
	       else {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon Note Duree DemiTons}|Acc} end
	    [] [N O] then
	       if Note==nil then {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon note(nom:{StringToAtom [N]} octave:{StringToInt [O]} alteration:none) Duree DemiTons}|Acc}
	       else {InterpreteAux nil nil Duree DemiTons {NoteToEchantillon Note Duree DemiTons}|Acc} end
	    end % fin case {AtomToString Atom}
	 end % fin case Partition
      end % fin fun {InterpreteAux Partition Note Duree DemiTons Acc}
      {Reverse {InterpreteAux  Partition nil 1 0 nil}}
	    
   end % fin local Faltten NoteToEchantillon Reverse InterpreteAux DureeTot
end % fin fun {Interprete Partition}

declare Partition = [a4 [a a5] a6 duree(seconde:1.0 [etirer(facteur:2.0 [a [a]])]) muet([a a a])duree(seconde:0.5 [transpose(demitons:~2 [a [a a]])]) bourdon(note:a5 [a a]) ]
{Browse {Interprete Partition}}