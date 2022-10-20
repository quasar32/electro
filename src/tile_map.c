#include <string.h>

#include "tile_map.h"
#include "util.h"

struct tile_map g_tm;

void init_tm(struct tile_map *tm)
{
	tm->rows = NULL;
	tm->w = 0;
	tm->h = 0;
}

void size_tm(struct tile_map *tm, int w, int h)
{
	uint8_t **rows;
	int mw, mh;
	int dw, dh;
	uint8_t **row;
	int n;

	/*clean old rows*/
	n = tm->h - h;
	row = tm->rows + h;
	while (n-- > 0) {
		free(*row++);
	}

	/*get new row pointers*/
	rows = xrealloc(tm->rows, h * sizeof(*rows));

	/*calc zero padding*/
	mw = MIN(w, tm->w);
	mh = MIN(h, tm->h);
	
	dw = w - mw;
	dh = h - mh;

	/*resize old rows*/
	row = rows;
	n = mh;
	while (n-- > 0) {
		*row = xrealloc(*row, w); 
		memset(*row + tm->w, 0, dw);
		row++;
	}

	/*resize new rows*/
	row = rows + tm->h;
	n = dh;
	while (n-- > 0) {
		*row++ = xcalloc(w, 1);
	}

	/*copy new values*/
	tm->w = w;
	tm->h = h;
	tm->rows = rows;
}

void reset_tm(struct tile_map *tm)
{
	uint8_t **row;
	int n;

	row = tm->rows;
	n = tm->h;
	while (n-- > 0) {
		free(*row);
		row++;	
	}
	free(tm->rows);

	init_tm(tm);
}
