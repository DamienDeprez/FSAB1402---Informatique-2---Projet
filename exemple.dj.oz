% Hymne à la joie.
local
   % Gamme utilisée pour les tests
	Partition = [c d e f g a b c5]
	TPartition=[ Partition duree(secondes:2.5 Partition) etirer(facteur:0.5 Partition) muet(Partition) bourdon(note:a5 Partition) transpose(demitons:12 Partition)]
	Musique1=[partition(Partition)]
	Musique2=[partition(TPartition)]
in
   % Ceci est une musique avec les transformations sur les musiques et les partitions
   [Musique2 repetition(nombre:2 Musique1) repetition(duree:4.0 Musique1) clip(bas:0.25 haut:0.1 Musique1) fondu_enchaine(duree:2.0 Musique1 Musique1) couper(debut:0.5 fin:2.0 Musique1)] 
	% avec [Musique2 repetition(nombre:2 Musique1) repetition(duree:4.0 Musique1) clip(bas:0.25 haut:0.1 Musique1) fondu_enchaine(duree:2.0 Musique1 Musique1) couper(debut:0.5 fin:2.0 Musique1) echo(delai:4.0 Musique1) echo(delai:4.0 decadence:0.5 Musique1) echo(delai:4.0 decadence:0.5 repetition:2 Musique1) renverser(Musique1)], nous avons l'erreur suivante dans mozart au moment de l'ecriture
	% du fichier au format .wav
	% la duree de la  musique est normalement de 146 secondes
		%FATAL: The active memory (732096708) after a GC is over the maximal heap size threshold: 732096600
		%Terminated VM 1
		%terminate called after throwing an instance of 'boost::exception_detail::clone_impl<boost::exception_detail::error_info_injector<boost::lock_error> >'
		%what():  boost: mutex lock failed in pthread_mutex_lock: Invalid argument
		%Aborted (core dumped)

		%Process Oz Emulator exited abnormally with code 134
end

