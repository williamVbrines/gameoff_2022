RSRC                  	   Resource            ��������                                                  resource_local_to_scene    resource_name    script    data       Script .   res://scenes/resources/dialogs/dialog_data.gd ��������      local://Resource_4wyko       	   Resource                       9         0             act             Show[text]       Wait[next]       con       true       def             Line[next]       1             act             Say[barnabas, What is it now?]       Line[next]       con       true       def             Line[next]       10             act          
   Show[opt]       Wait[]       con       true       def             Line[next]       11             act             Show[text]       Wait[next]       con       true       def             Line[next]       12             act          (   Say[barnabas, Watcher of the dog-star!]       Line[next]       con       true       def             Line[next]       13             act             Show[text]       Wait[next]       con       true       def             Line[next]       14             act          +   Say[barnabas, Traveler of the Frog-Lands!]       Line[next]       con       true       def             Line[next]       15             act             Show[text]       Wait[next]       con       true       def             Line[next]       16             act          ;   Say[barnabas, Deviser of the self-polishing crystal ball!]       Line[next]       con       true       def             Line[next]       17             act             Show[text]       Wait[Questions]       con       true       def             Line[next]       18             act             Show[text]       Wait[next]       con       true       def             Line[next]       19             act          8   Say[barnabas, I'd look like some befuddled old geezer!]       Set[player,FirstAsk,true]       Line[next]       con       true       def             Line[next]       2             act             Show[text]       Wait[Questions]       con       true       def             Line[next]       20             act             Show[text]       Wait[Questions]       con       true       def             Line[next]       21             act             Show[text]       Wait[next]       con       true       def             Line[next]       22             act          2   Say[player, I heard Margo likes Jacues' beard...]       Line[next]       con       player[MargoLike]       def             Line[Questions]       23             act             Show[text]       Wait[next]       con       true       def             Line[next]       24             act             Say[barnabas, Ah...]       Line[next]       con       true       def             Line[next]       25             act             Show[text]       Wait[next]       con       true       def             Line[next]       26             act             Say[barnabas, Does she now...]       Line[next]       con       true       def             Line[next]       27             act             Show[text]       Wait[next]       con       true       def             Line[next]       28             act          /   Say[player, I gave her some flowers from you.]       Line[next]       con       player[GaveFlowers]       def             Line[Questions]       29             act             Show[text]       Wait[next]       con       true       def             Line[next]       3             act             Show[text]       Wait[Questions]       con       true       def             Line[next]       30             act          u   Say[player, She seemed touched. You mighe have an even better chance at her affections if you were to grow a beard.]       Line[next]       con       true       def             Line[next]       31             act             Show[text]       Wait[next]       con       true       def             Line[next]       32             act          0   Say[barnabas, You know what? I'll concider it.]        Set[barnabas,per,40]        Line[next]       con       true       def             Line[next]       33             act             Show[text]       Wait[Bail]       con       true       def             Line[next]       34             act             Opt[Jacque, Ask about Jacque]       Line[next]       con       true       def             Line[next]       35             act          
   Show[opt]       Wait[]       con       true       def             Line[next]       36             act             Show[text]       Wait[next]       con       true       def             Line[next]       37             act          :   Say[barnabas, I've been quite fond of her for some time.]       Line[next]       con       true       def             Line[next]       38             act             Show[text]       Wait[Questions]       con       true       def             Line[next]       39             act             Show[text]       Wait[next]       con       true       def             Line[next]       4             act          5   Opt[StartBattle, Try to persuade (!!Start Battle!!)]       Line[next]       con       true       def             Line[next]       40             act          r   Say[barnabas, Utterly inconsequential, but he thinks he's some kind of someone now that he's caught Margo's eye.]       Line[next]       con       true       def             Line[next]       41             act             Show[text]       Wait[Questions]       con       true       def             Line[next]       42             act              con              def              5             act             Opt[More , More Options...]       Line[next]       con       true       def             Line[next]       6             act          
   Show[opt]       Wait[]       con       true       def             Line[next]       7             act             Opt[Bail, Leave]       Line[next]       con       true       def             Line[next]       8             act          
   Show[opt]       Wait[]       con       true       def             Line[next]       9             act          %   Opt[Beard1, Ask him to grow a beard]       Line[next]       con       true       def             Line[next]       Bail             act             Hide[]       con       true       def             Line[next]       Barn             act          !   Opt[Bio, Ask about what he does]       Line[next]       con       true       def             Line[next]       Beard1             act             Line[Beard2]       con       player[FirstAsk]       def          1   Say[barnabas, Why in the world would I do that?]       Line[next]       Beard2             act          H   Say[barnabas, I told you once: I have no intention of growing a beard!]       Line[next]       con       true       def             Line[next]       Bio             act          F   Say[barnabas, I am the formidable Barnabas Bombastus VonRichtenberg!]       Line[next]       con       true       def             Line[next]       First             act          *   Say[barnabas, What do you want stranger?]       Set[player,NotFirstTime,true]       Line[next]       con       true       def             Line[next]       Folk             act             Opt[Margo, Ask about Margo]       Line[next]       con       true       def             Line[next]       Jacque             act          -   Say[barnabas, Peshaw! Think nothing of him!]       Line[next]       con       true       def             Line[next]       Margo             act          -   Say[barnabas, Ah, She's a remarkable woman.]       Line[next]       con       true       def             Line[next]       More             act          #   Opt[Folk, Ask about the townsfolk]       Line[next]       con       true       def             Line[next]    
   Questions             act             Opt[Barn, Ask about him]       Line[next]       con       true       def             Line[next]       Start             act             Say[barnabas, You again?]       Line[next]       con       player[NotFirstTime]       def             Line[First]       StartBattle             act             Emit[StartBattle]        Line[Bail]       con       true       def             Line[next]       order    8         Start       0       1       2       First       3    
   Questions       4       5       6       More       7       8       Bail       Barn       9       10       Bio       11       12       13       14       15       16       17       Beard1       18       19       20       Beard2       21       22       23       24       25       26       27       28       29       30       31       32       33       Folk       34       35       Margo       36       37       38       Jacque       39       40       41       StartBattle       42 RSRC