turtles-own [
  hours
  speed
  known-vaccinated
  known-illnesses
  can-vaccinate
]

globals [
  start-speed
]

to setup
  clear-all
  reset-ticks
  set start-speed 0.5

  create-turtles people-count [
    setxy random-xcor random-ycor
    set shape "person"
    set color green
    set speed start-speed
    set known-vaccinated 0
    set known-illnesses 0
    set can-vaccinate true
  ]

  ask one-of turtles [
    set color orange
  ]
end


to go
  ask turtles [
    fd speed * (1 - 1 / social-distance)
    right 45 - random 90
    set hours hours + 1
  ]

  ask turtles [
    if (color = orange) [
      ask turtles in-radius 0.5 [
        if random 100 < infection-probability  [
          if color = green [
            set color orange
            set hours 0
            ask my-links [die]
          ]
        ]
      ]
    ]

;    if (color = red) [
;      create-links-with other turtles with [color = green] in-radius 1
;    ]
;
;    if (color = blue) [
;      create-links-with other turtles with [color = green] in-radius 1
;    ]

    if (color = orange) and (hours = (incubation-time * 24)) [
      ifelse (random 100 < symptom-rate) [
         set color red
         set speed 0
         set hours 0
      ]
      [
        set color cyan
        set hours 0
      ]
    ]

    if (color = red) and (hours = (4 * 24)) [
      ifelse (random 100 < hospitalization-rate) [
        set color pink
        set hours 0
      ]
      [
        set color cyan
        set speed start-speed
        set hours 0
      ]
    ]

    if (color = pink) and (hours = (illness-duration * 24)) [
      ifelse random 100 < severity-rate [
        set color violet
        set hours 0
      ]
      [
        set color cyan
        set hours 0
        set speed start-speed
      ]

    ]

    if (color = violet) and (hours = (illness-duration * 24)) [
      ifelse random 100 < death-rate [
        set color gray
        set hours 0
      ]
      [
        set color cyan
        set hours 0
        set speed start-speed

      ]
    ]
    if (color = green) and (can-vaccinate) [
      if ((count my-links) > 5) [
        set color blue
        set hours 0
        set speed start-speed
      ]
    ]
  ]

  if finished? [stop]
  tick
end


to-report finished?
  if (count turtles with [color = orange] = 0) and
  (count turtles with [color = red] = 0) and
  (count turtles with [color = violet] = 0)
  [
    report true
  ]

  report false
end
@#$#@#$#@
GRAPHICS-WINDOW
495
87
2596
1409
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-80
80
-50
50
0
0
1
ticks
30.0

BUTTON
2823
776
2958
810
Setup simulation
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
2960
776
3108
810
Run simulation
go
T
1
T
OBSERVER
NIL
R
NIL
NIL
1

SLIDER
34
577
206
610
people-count
people-count
0
10000
7000.0
200
1
NIL
HORIZONTAL

SLIDER
36
84
240
117
infection-probability
infection-probability
0
100
10.0
1
1
%
HORIZONTAL

SLIDER
37
139
239
172
incubation-time
incubation-time
0
27
5.0
1
1
days
HORIZONTAL

SLIDER
37
202
237
235
severity-rate
severity-rate
0
100
34.0
1
1
%
HORIZONTAL

SLIDER
37
275
239
308
death-rate
death-rate
0
100
42.0
1
1
%
HORIZONTAL

SLIDER
35
396
239
429
illness-duration
illness-duration
0
50
10.0
1
1
days
HORIZONTAL

PLOT
2829
166
3173
394
How many people are...
hours
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"healthy" 1.0 0 -13840069 true "" "plot count turtles with [color = green]"
"infected" 1.0 0 -955883 true "" "plot count turtles with [color = orange]"
"ill" 1.0 0 -2674135 true "" "plot count turtles with [color = red]"
"severe" 1.0 0 -8630108 true "" "plot count turtles with [color = violet]"
"immune" 1.0 0 -8990512 true "" "plot count turtles with [color = cyan]"
"dead" 1.0 0 -7500403 true "" "plot count turtles with [color = gray]"
"vaccinated" 1.0 0 -15390905 true "" "plot count turtles with [color = blue]"
"hospitalized" 1.0 0 -1664597 true "" "plot count turtles with [color = pink]"

MONITOR
3070
439
3191
484
Dead %
count turtles with [color = gray] / people-count * 100
3
1
11

MONITOR
2842
437
2923
482
Days passed
ticks / 24
1
1
11

TEXTBOX
36
34
246
67
Facts about the illness
15
0.0
1

TEXTBOX
36
59
249
81
How likely are people to contract the disease from contact?
8
0.0
1

TEXTBOX
37
126
241
150
How long before first symptoms show up?
8
0.0
1

TEXTBOX
37
176
245
196
How many hospitalized people need to go the ICU?
8
0.0
1

TEXTBOX
40
256
237
278
How many people in the ICU do not survive?\t
8
0.0
1

TEXTBOX
37
371
245
392
How long are people ill? Also long will people need to go to the hospital?
8
0.0
1

TEXTBOX
37
480
244
504
To what degree do people refrain from interaction?
8
0.0
1

TEXTBOX
36
453
256
472
Facts about behavior
15
0.0
1

MONITOR
2927
438
3062
483
Unaffected %
count turtles with [color = green] / people-count * 100
2
1
11

BUTTON
2962
812
3110
846
Step simulation
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
467
20
694
44
Flatten the curve
22
0.0
1

TEXTBOX
2698
785
2848
803
First, click here ->
13
15.0
1

TEXTBOX
3117
785
3267
803
<- Next, click here
12
15.0
1

SLIDER
2839
534
3077
567
acute-care-hospital-beds
acute-care-hospital-beds
0
30
9.0
1
1
NIL
HORIZONTAL

SLIDER
2839
598
3019
631
icu-hospital-beds
icu-hospital-beds
0
10
2.0
1
1
NIL
HORIZONTAL

SLIDER
255
87
428
120
symptom-rate
symptom-rate
0
100
20.0
1
1
%
HORIZONTAL

SLIDER
35
514
207
547
social-distance
social-distance
0
1
0.8
0.1
1
NIL
HORIZONTAL

SLIDER
251
138
463
171
hospitalization-rate
hospitalization-rate
0
100
15.0
1
1
%
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

This is a model that explains how the spread of disease affects a community. It incorporates a three stage illness model and a spatial model of contagion.

Two remedies are modeled: Hospital size and social distancing. 

## HOW IT WORKS

Agents walk around in "random walks" simulating normal social behavior. 
One agent has become infected but is in incubation time. During incubation time behavior is normal but other agents can become infected. Whether or not an agent gets affected depends on the infection-probability.
After the incubation-time agents become ill and reduce their social interaction by stopping movement. They are still infections if other agents "visit" them.
After the illness-duration agents can become severly-ill, depending on the severity-rate.
Severly ill agents no longer infect other agents as they are in isolation.
When no hospital beds are available severly ill agents die. 
All other severly ill agents recover after another illness-duration.
With the exception of some agents. Depending on the death-rate some agents do not recover from severe illness.

Social distancing regulates the distances travelled by each agent and thus also the amount of possible interaction. Strong social distancing reduces community spread, but
increases the likelihood of infecting very near agents (infecting other household members in quarantine).

## HOW TO USE IT

The model calculates an expected rate of deaths from the illness information.
By manipulating social distancing and hotel capacity (with respect to total agents) different outcomes can occur.

As outcome variables the overall duration of the epidemic is shown as well as the amount of agents that have died.

## THINGS TO NOTICE

The amount of ill people grows exponentially leading to a quick reduction in social interaction. When the hospital capacity reaches zero, death rate increases drastically.

## THINGS TO TRY

Try exploring the social distancing and hospital capacity sliders for fixed population sizes. You can restart the simulation by pressing the "S" key and run the simulation by pressing the "R" key. This allows to quickly compare model runs.

In the default configuration interesting differences occur between 0.7 and 0.95 social distancing.

## EXTENDING THE MODEL

This model assumes fixed times. Extensions could include random incubation periods, random illness-durations and more agent heterogeneity. Currently all agents are affected equally from the disease. Age or gender dependent reactions could be implemented.

The spatial model is a high level of abstraction from real human interaction.


## CREDITS AND REFERENCES

by André Calero Valdez (@sumidu) web calerovaldez.com
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Test with 100 agents" repetitions="5" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>finished?</exitCondition>
    <metric>count turtles with [color = gray] / people-count * 100</metric>
    <metric>count turtles with [color = green] / people-count * 100</metric>
    <enumeratedValueSet variable="people-count">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hospital-capacity">
      <value value="10"/>
      <value value="20"/>
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="incubation-time">
      <value value="5"/>
      <value value="7"/>
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="illness-duration">
      <value value="10"/>
      <value value="14"/>
      <value value="21"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death-rate">
      <value value="15"/>
      <value value="20"/>
      <value value="25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="social-distance">
      <value value="0.3"/>
      <value value="0.5"/>
      <value value="0.75"/>
      <value value="0.95"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="infection-probability">
      <value value="1"/>
      <value value="3"/>
      <value value="5"/>
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="severity-rate">
      <value value="15"/>
      <value value="20"/>
      <value value="25"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
