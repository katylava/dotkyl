#!/usr/bin/env python2

fgtpl = "[38;5;{color}m{text:>4}[m"
bgtpl = "[48;5;{color}m [30m{text:>3} [m"

fgs = []
bgs = []

for color in range(0,256):
    kwargs = {'color': color, 'text': color}
    fgs.append(fgtpl.format(**kwargs))
    bgs.append(bgtpl.format(**kwargs))


tpl = """
{16} {232}{233}{234}{235}{236}{237}{238} {239}{240}
{59} {241}{242}{243}{244}{102} {245}{246}{247}{248}
{145}{249}{250}{251} {252}{253}{188}{254}{255}{231}

{52} {88}  {124} {160} {196} |{203}|{167}|{131}|{95} |{138}|{181}|{224}|{217}|{174}|{210}|{203}|
{52} {88}  {124} {160} {196} |{209}|{167}|{131}|{95} |{138}|{181}|{224}|{217}|{174}|{210}|{209}|
{52} {88}  {124} {160} {196} |{209}|{173}|{131}|{95} |{138}|{181}|{224}|{217}|{174}|{210}|{209}|
{52} {88}  {124} {160} {196} |{209}|{173}|{131}|{95} |{138}|{181}|{224}|{217}|{174}|{216}|{209}|
{52} {88}  {124} {160} {202} |{209}|{173}|{131}|{95} |{138}|{181}|{224}|{217}|{174}|{216}|{209}|
{52} {88}  {124} {166} {202} |{209}|{173}|{131}|{95} |{138}|{181}|{224}|{217}|{174}|{216}|{209}|
{52} {88}  {124} {166} {202} |{209}|{173}|{131}|{95} |{138}|{181}|{224}|{217}|{180}|{216}|{209}|
{52} {88}  {124} {166} {202} |{215}|{173}|{137}|{95} |{138}|{181}|{224}|{217}|{180}|{216}|{215}|
{52} {88}  {124} {166} {208} |{215}|{173}|{137}|{95} |{138}|{181}|{224}|{217}|{180}|{216}|{215}|
{52} {88}  {130} {166} {208} |{215}|{173}|{137}|{95} |{138}|{181}|{224}|{217}|{180}|{216}|{215}|
{52} {88}  {130} {172} {208} |{215}|{173}|{137}|{95} |{138}|{181}|{224}|{223}|{180}|{216}|{215}|
{52} {88}  {130} {172} {208} |{215}|{179}|{137}|{95} |{138}|{181}|{224}|{223}|{180}|{216}|{215}|
{52} {88}  {130} {172} {214} |{215}|{179}|{137}|{95} |{138}|{181}|{224}|{223}|{180}|{216}|{215}|
{52} {94}  {130} {172} {214} |{215}|{179}|{137}|{95} |{138}|{181}|{224}|{223}|{180}|{216}|{215}|
{52} {94}  {130} {172} {214} |{215}|{179}|{137}|{95} |{138}|{181}|{224}|{223}|{180}|{222}|{215}|
{52} {94}  {136} {172} {214} |{215}|{179}|{137}|{95} |{138}|{181}|{224}|{223}|{180}|{222}|{215}|
{52} {94}  {136} {178} {214} |{215}|{179}|{137}|{95} |{138}|{181}|{224}|{223}|{180}|{222}|{215}|
{52} {94}  {136} {178} {214} |{221}|{179}|{137}|{95} |{138}|{181}|{224}|{223}|{180}|{222}|{221}|
{52} {94}  {136} {178} {220} |{221}|{179}|{137}|{95} |{138}|{181}|{224}|{223}|{180}|{222}|{221}|
{58} {100} {142} {184} {226} |{227}|{185}|{143}|{101}|{144}|{187}|{230}|{229}|{186}|{228}|{227}|
{58} {100} {142} {184} {190} |{227}|{185}|{143}|{101}|{144}|{187}|{230}|{229}|{186}|{228}|{227}|
{58} {100} {142} {148} {190} |{191}|{185}|{143}|{101}|{144}|{187}|{230}|{229}|{186}|{228}|{191}|
{58} {100} {106} {148} {190} |{191}|{185}|{143}|{101}|{144}|{187}|{230}|{229}|{186}|{228}|{191}|
{58} {100} {106} {148} {190} |{191}|{185}|{143}|{101}|{144}|{187}|{230}|{229}|{186}|{192}|{191}|
{58} {64}  {106} {148} {190} |{191}|{185}|{143}|{101}|{144}|{187}|{230}|{229}|{186}|{192}|{191}|
{58} {64}  {106} {148} {154} |{191}|{185}|{143}|{101}|{144}|{187}|{230}|{229}|{186}|{192}|{191}|
{58} {64}  {106} {148} {154} |{191}|{149}|{143}|{101}|{144}|{187}|{230}|{229}|{186}|{192}|{191}|
{58} {64}  {106} {112} {154} |{191}|{149}|{143}|{101}|{144}|{187}|{230}|{193}|{186}|{192}|{191}|
{58} {64}  {70}  {112} {154} |{191}|{149}|{143}|{101}|{144}|{187}|{230}|{193}|{186}|{192}|{191}|
{58} {64}  {70}  {112} {118} |{191}|{149}|{143}|{101}|{144}|{187}|{230}|{193}|{186}|{192}|{191}|
{58} {64}  {70}  {112} {118} |{155}|{149}|{107}|{101}|{144}|{187}|{230}|{193}|{186}|{192}|{155}|
{58} {64}  {70}  {112} {118} |{155}|{149}|{107}|{101}|{144}|{187}|{230}|{193}|{150}|{192}|{155}|
{58} {64}  {70}  {76}  {118} |{155}|{149}|{107}|{101}|{144}|{187}|{230}|{193}|{150}|{192}|{155}|
{58} {64}  {70}  {76}  {82}  |{155}|{149}|{107}|{101}|{144}|{187}|{230}|{193}|{150}|{192}|{155}|
{58} {64}  {70}  {76}  {82}  |{155}|{149}|{107}|{101}|{144}|{187}|{230}|{193}|{150}|{156}|{155}|
{58} {64}  {70}  {76}  {82}  |{155}|{113}|{107}|{101}|{144}|{187}|{230}|{193}|{150}|{156}|{155}|
{58} {64}  {70}  {76}  {82}  |{119}|{113}|{107}|{101}|{144}|{187}|{230}|{193}|{150}|{156}|{119}|
{22} {28}  {34}  {40}  {46}  |{83} |{77} |{71} |{65} |{108}|{151}|{194}|{157}|{114}|{120}|{83} |
{22} {28}  {34}  {40}  {46}  |{84} |{77} |{71} |{65} |{108}|{151}|{194}|{157}|{114}|{120}|{84} |
{22} {28}  {34}  {40}  {46}  |{84} |{78} |{71} |{65} |{108}|{151}|{194}|{157}|{114}|{120}|{84} |
{22} {28}  {34}  {40}  {46}  |{84} |{78} |{71} |{65} |{108}|{151}|{194}|{157}|{114}|{121}|{84} |
{22} {28}  {34}  {40}  {47}  |{84} |{78} |{71} |{65} |{108}|{151}|{194}|{157}|{114}|{121}|{84} |
{22} {28}  {34}  {41}  {47}  |{84} |{78} |{71} |{65} |{108}|{151}|{194}|{157}|{114}|{121}|{84} |
{22} {28}  {34}  {41}  {47}  |{84} |{78} |{71} |{65} |{108}|{151}|{194}|{157}|{115}|{121}|{84} |
{22} {28}  {34}  {41}  {47}  |{85} |{78} |{72} |{65} |{108}|{151}|{194}|{157}|{115}|{121}|{85} |
{22} {28}  {34}  {41}  {48}  |{85} |{78} |{72} |{65} |{108}|{151}|{194}|{157}|{115}|{121}|{85} |
{22} {28}  {35}  {41}  {48}  |{85} |{78} |{72} |{65} |{108}|{151}|{194}|{157}|{115}|{121}|{85} |
{22} {28}  {35}  {42}  {48}  |{85} |{78} |{72} |{65} |{108}|{151}|{194}|{158}|{115}|{121}|{85} |
{22} {28}  {35}  {42}  {48}  |{85} |{79} |{72} |{65} |{108}|{151}|{194}|{158}|{115}|{121}|{85} |
{22} {28}  {35}  {42}  {49}  |{85} |{79} |{72} |{65} |{108}|{151}|{194}|{158}|{115}|{121}|{85} |
{22} {29}  {35}  {42}  {49}  |{85} |{79} |{72} |{65} |{108}|{151}|{194}|{158}|{115}|{121}|{85} |
{22} {29}  {35}  {42}  {49}  |{85} |{79} |{72} |{65} |{108}|{151}|{194}|{158}|{115}|{122}|{85} |
{22} {29}  {36}  {42}  {49}  |{85} |{79} |{72} |{65} |{108}|{151}|{194}|{158}|{115}|{122}|{85} |
{22} {29}  {36}  {43}  {49}  |{86} |{79} |{72} |{65} |{108}|{151}|{194}|{158}|{115}|{122}|{86} |
{22} {29}  {36}  {43}  {50}  |{86} |{79} |{72} |{65} |{108}|{151}|{194}|{158}|{115}|{122}|{86} |
{23} {30}  {37}  {44}  {51}  |{87} |{80} |{73} |{66} |{109}|{152}|{195}|{159}|{116}|{123}|{87} |
{23} {30}  {37}  {44}  {45}  |{87} |{80} |{73} |{66} |{109}|{152}|{195}|{159}|{116}|{123}|{87} |
{23} {30}  {37}  {38}  {45}  |{81} |{80} |{73} |{66} |{109}|{152}|{195}|{159}|{116}|{123}|{81} |
{23} {30}  {31}  {38}  {45}  |{81} |{80} |{73} |{66} |{109}|{152}|{195}|{159}|{116}|{123}|{81} |
{23} {30}  {31}  {38}  {45}  |{81} |{80} |{73} |{66} |{109}|{152}|{195}|{159}|{116}|{117}|{81} |
{23} {24}  {31}  {38}  {45}  |{81} |{80} |{73} |{66} |{109}|{152}|{195}|{159}|{116}|{117}|{81} |
{23} {24}  {31}  {38}  {39}  |{81} |{80} |{73} |{66} |{109}|{152}|{195}|{159}|{116}|{117}|{81} |
{23} {24}  {31}  {38}  {39}  |{81} |{74} |{73} |{66} |{109}|{152}|{195}|{159}|{116}|{117}|{81} |
{23} {24}  {31}  {32}  {39}  |{81} |{74} |{73} |{66} |{109}|{152}|{195}|{159}|{116}|{117}|{81} |
{23} {24}  {31}  {32}  {39}  |{81} |{74} |{73} |{66} |{109}|{152}|{195}|{153}|{116}|{117}|{81} |
{23} {24}  {25}  {32}  {39}  |{81} |{74} |{73} |{66} |{109}|{152}|{195}|{153}|{116}|{117}|{81} |
{23} {24}  {25}  {32}  {33}  |{81} |{74} |{73} |{66} |{109}|{152}|{195}|{153}|{116}|{117}|{81} |
{23} {24}  {25}  {32}  {33}  |{75} |{74} |{67} |{66} |{109}|{152}|{195}|{153}|{116}|{117}|{75} |
{23} {24}  {25}  {32}  {33}  |{75} |{74} |{67} |{66} |{109}|{152}|{195}|{153}|{110}|{117}|{75} |
{23} {24}  {25}  {26}  {33}  |{75} |{74} |{67} |{66} |{109}|{152}|{195}|{153}|{110}|{117}|{75} |
{23} {24}  {25}  {26}  {27}  |{75} |{74} |{67} |{66} |{109}|{152}|{195}|{153}|{110}|{117}|{75} |
{23} {24}  {25}  {26}  {27}  |{75} |{74} |{67} |{66} |{109}|{152}|{195}|{153}|{110}|{111}|{75} |
{23} {24}  {25}  {26}  {27}  |{75} |{68} |{67} |{66} |{109}|{152}|{195}|{153}|{110}|{111}|{75} |
{23} {24}  {25}  {26}  {27}  |{69} |{68} |{67} |{66} |{109}|{152}|{195}|{153}|{110}|{111}|{69} |
{17} {18}  {19}  {20}  {21}  |{63} |{62} |{61} |{60} |{103}|{146}|{189}|{147}|{104}|{105}|{63} |
{17} {18}  {19}  {20}  {21}  |{99} |{62} |{61} |{60} |{103}|{146}|{189}|{147}|{104}|{105}|{99} |
{17} {18}  {19}  {20}  {21}  |{99} |{98} |{61} |{60} |{103}|{146}|{189}|{147}|{104}|{105}|{99} |
{17} {18}  {19}  {20}  {21}  |{99} |{98} |{61} |{60} |{103}|{146}|{189}|{147}|{104}|{141}|{99} |
{17} {18}  {19}  {20}  {57}  |{99} |{98} |{61} |{60} |{103}|{146}|{189}|{147}|{104}|{141}|{99} |
{17} {18}  {19}  {56}  {57}  |{99} |{98} |{61} |{60} |{103}|{146}|{189}|{147}|{104}|{141}|{99} |
{17} {18}  {19}  {56}  {57}  |{99} |{98} |{61} |{60} |{103}|{146}|{189}|{147}|{140}|{141}|{99} |
{17} {18}  {19}  {56}  {57}  |{135}|{98} |{97} |{60} |{103}|{146}|{189}|{147}|{140}|{141}|{135}|
{17} {18}  {19}  {56}  {93}  |{135}|{98} |{97} |{60} |{103}|{146}|{189}|{147}|{140}|{141}|{135}|
{17} {18}  {55}  {56}  {93}  |{135}|{98} |{97} |{60} |{103}|{146}|{189}|{147}|{140}|{141}|{135}|
{17} {18}  {55}  {92}  {93}  |{135}|{98} |{97} |{60} |{103}|{146}|{189}|{183}|{140}|{141}|{135}|
{17} {18}  {55}  {92}  {93}  |{135}|{134}|{97} |{60} |{103}|{146}|{189}|{183}|{140}|{141}|{135}|
{17} {18}  {55}  {92}  {129} |{135}|{134}|{97} |{60} |{103}|{146}|{189}|{183}|{140}|{141}|{135}|
{17} {54}  {55}  {92}  {129} |{135}|{134}|{97} |{60} |{103}|{146}|{189}|{183}|{140}|{141}|{135}|
{17} {54}  {55}  {92}  {129} |{135}|{134}|{97} |{60} |{103}|{146}|{189}|{183}|{140}|{177}|{135}|
{17} {54}  {91}  {92}  {129} |{135}|{134}|{97} |{60} |{103}|{146}|{189}|{183}|{140}|{177}|{135}|
{17} {54}  {91}  {128} {129} |{135}|{134}|{97} |{60} |{103}|{146}|{189}|{183}|{140}|{177}|{135}|
{17} {54}  {91}  {128} {129} |{171}|{134}|{97} |{60} |{103}|{146}|{189}|{183}|{140}|{177}|{171}|
{17} {54}  {91}  {128} {165} |{171}|{134}|{97} |{60} |{103}|{146}|{189}|{183}|{140}|{177}|{171}|
{53} {90}  {127} {164} {201} |{207}|{170}|{133}|{96} |{139}|{182}|{225}|{219}|{176}|{213}|{207}|
{53} {90}  {127} {164} {200} |{207}|{170}|{133}|{96} |{139}|{182}|{225}|{219}|{176}|{213}|{207}|
{53} {90}  {127} {163} {200} |{206}|{170}|{133}|{96} |{139}|{182}|{225}|{219}|{176}|{213}|{206}|
{53} {90}  {126} {163} {200} |{206}|{170}|{133}|{96} |{139}|{182}|{225}|{219}|{176}|{213}|{206}|
{53} {90}  {126} {163} {200} |{206}|{170}|{133}|{96} |{139}|{182}|{225}|{219}|{176}|{212}|{206}|
{53} {89}  {126} {163} {200} |{206}|{170}|{133}|{96} |{139}|{182}|{225}|{219}|{176}|{212}|{206}|
{53} {89}  {126} {163} {199} |{206}|{170}|{133}|{96} |{139}|{182}|{225}|{219}|{176}|{212}|{206}|
{53} {89}  {126} {163} {199} |{206}|{169}|{133}|{96} |{139}|{182}|{225}|{219}|{176}|{212}|{206}|
{53} {89}  {126} {162} {199} |{206}|{169}|{133}|{96} |{139}|{182}|{225}|{219}|{176}|{212}|{206}|
{53} {89}  {126} {162} {199} |{206}|{169}|{133}|{96} |{139}|{182}|{225}|{218}|{176}|{212}|{206}|
{53} {89}  {125} {162} {199} |{206}|{169}|{133}|{96} |{139}|{182}|{225}|{218}|{176}|{212}|{206}|
{53} {89}  {125} {162} {198} |{206}|{169}|{133}|{96} |{139}|{182}|{225}|{218}|{176}|{212}|{206}|
{53} {89}  {125} {162} {198} |{205}|{169}|{132}|{96} |{139}|{182}|{225}|{218}|{176}|{212}|{205}|
{53} {89}  {125} {162} {198} |{205}|{169}|{132}|{96} |{139}|{182}|{225}|{218}|{175}|{212}|{205}|
{53} {89}  {125} {161} {198} |{205}|{169}|{132}|{96} |{139}|{182}|{225}|{218}|{175}|{212}|{205}|
{53} {89}  {125} {161} {197} |{205}|{169}|{132}|{96} |{139}|{182}|{225}|{218}|{175}|{212}|{205}|
{53} {89}  {125} {161} {197} |{205}|{169}|{132}|{96} |{139}|{182}|{225}|{218}|{175}|{211}|{205}|
{53} {89}  {125} {161} {197} |{205}|{168}|{132}|{96} |{139}|{182}|{225}|{218}|{175}|{211}|{205}|
{53} {89}  {125} {161} {197} |{204}|{168}|{132}|{96} |{139}|{182}|{225}|{218}|{175}|{211}|{204}|
"""

tpl = tpl.replace(' ', '').replace('|','')

print tpl.format(*bgs, sp=' '*5)
print tpl.format(*fgs, sp=' '*4)
