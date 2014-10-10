mouseMove = (e)->
  mouse.vx = e.pageX - mouse.x
  mouse.vy = e.pageY - mouse.y

  mouse.x = e.pageX
  mouse.y = e.pageY

@.draw = ->
  clear()
  
  balls.forEach (d) ->

    distance = Math.sqrt(Math.pow(mouse.x - d.x, 2) + Math.pow(mouse.y - d.y, 2))
    if distance < 60
      d.repulsing = true
      d.vx = (mouse.vx + d.vx) * 0.3
      d.vy = (mouse.vy + d.vy) * 0.3
    else if d.repulsing and d.vx > 1 and d.vy > 1
      d.vx *= 0.99
      d.vy *= 0.99
    else
      d.repulsing = false
      d.vx = (d.home.x - d.x) * 0.05
      d.vy = (d.home.y - d.y) * 0.05

    gravitate(d)
    move(d)

    c.beginPath()
    c.lineWidth = 0.5
    c.strokeStyle = "#000000"
    c.arc(d.x, d.y, d.r, 0, Math.PI * 2, true)
    c.stroke()
    c.closePath()

# Create a grid, 10 x 10

left = center.x - 250
top  = center.y - 250

balls = [1..100].map (d, i, lisr) ->
  x: i % 10 * 50 + left
  y: Math.floor(i * 0.1) * 10 * 5 + top
  home:
    x: i % 10 * 50 + left
    y: Math.floor(i * 0.1) * 10 * 5 + top
  vx: 0
  vy: 0
  r: 8

gravitate = (a) ->
# a.vx = (a.home.x - a.x) * 0.05
# a.vy = (a.home.y - a.y) * 0.05

move = (a)->
  a.x += a.vx
  a.y += a.vy

mouse =
  vx: 0
  vy: 0
  x: 0
  y: 0

addEventListener 'mousemove', mouseMove, false