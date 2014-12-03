
local
   % Gamme utilisée pour les tests
   Partition = [c d e f g a b c5]
  	Duree=duree(secondes:2.3 Partition)
	Muet=muet(Partition)
	Bourdon=bourdon(note:a3 Partition)
	Etirer=etirer(facteur:2.3 Partition)
	Transpose=transpose(demitons:3 Partition)
	Transfo=[Bourdon Transpose]
   PartitionAvecTransfo=[Partition Transfo]
   Musique=[partition(PartitionAvecTransfo)]
   
   %Merge=merge([0.5#[partition(Partition)] 0.3#[wave(horse.wav)]])
   Repetition=[repetition(nombre:2 Musique)]
   Echo=echo(delai:2.5 decadence:1.3 repetition:3 Musique)
   %Couper=couper(debut:0.48 fin:3.32 Musique)
   %Renverser=renverser(Musique)
  % Clip=clip(bas:0.0 haut:1.2 Musique)
   %[Clip Repetition Echo Couper Renverser]
in
   % Ceci est une musique avec les transformations sur les musiques et les partitions
  Musique
end

