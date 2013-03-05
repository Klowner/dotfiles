function conky_mypie()
	if conky_window==nil then return end

	local w = conky_window.width
	local h = conky_window.height
	local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, w, h)
	cr = cairo_create(cs)

	draw_pie({
		tableV={
			{"ees", "", "12", 100, "%"},
		},
		xc=0,
		yc=12,
		show_text=true,
		txt_font='gelly',
		font_size=10,
		font_alpha=0.2,
		int_radius=95,
		radius=100,
		type_arc='l',
		inverse_l_arc=true,
		gradient_effect=false,
		first_angle=90,
		last_angle=180,
		tablebg={
			{0x0, 0.05},
			{0x0, 0.05},
		},
		tablefg={
			{0x0, 0.5},
			{0x0, 0.5},
		}
	})

	cairo_destroy(cr)
end
