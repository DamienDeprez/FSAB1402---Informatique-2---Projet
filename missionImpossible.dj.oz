local

T1=[g3 etirer(facteur:0.5 [silence]) etirer(facteur:1.5 g3) a#3 c4 g3 etirer(facteur:0.5 [silence]) etirer(facteur:1.5 g3)]
T2=[etirer(facteur:2.0 [silence]) etirer(facteur:0.5 a#5) etirer(facteur:0.5 g5)]

Int=[etirer(facteur:2.0 [silence]) etirer(facteur:0.5 a#5) etirer(facteur:0.5 c5) etirer(facteur:4.0 [silence])]
T3= [a#3 etirer(facteur:0.5 [silence]) etirer(facteur:1.5 a#3)]
T4=[etirer(facteur:0.5 a#4) etirer(facteur:0.5 a#4) etirer(facteur:2.0 f#5)]
Partition1=[T1 [f3 f#3] T1 T2 etirer(facteur:2.0 d5) T2 etirer(facteur:2.0 c#5) T2 etirer(facteur:2.0 c5) Int T3 a#4 c5 T3 f4 f#4 g4 T4 etirer(facteur:2.0 [silence]) T4]


Tune1=[g2 etirer(facteur:0.5 [silence]) etirer(facteur:1.5 g2) a#2 c3]
Tune2=[g2 etirer(facteur:0.5 [silence]) etirer(facteur:1.5 g2) f2 f#2]
Partition2=[Tune1 Tune2 Tune1 Tune2 Tune1 Tune2 Tune1 Tune2 Tune1 Tune2 Tune1 Tune2]

Music1=[partition(Partition1)]
Music2=[partition([etirer(facteur:40.0 [silence]) d4 etirer(facteur:0.5 [silence]) etirer(facteur:1.5 d4)])]
Music3=[partition([etirer(facteur:40.0 [silence]) g4 etirer(facteur:0.5 [silence]) etirer(facteur:1.5 g4)])]
Music4=[partition(Partition2)]
in
[merge([0.25#Music1 0.25#Music2 0.25#Music3 0.25#Music4])]
end
