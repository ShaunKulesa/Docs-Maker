# NAME

Tk_CanvasTextInfo - additional information for managing text items in
canvases

# SYNOPSIS

    #include <tk.h>

    Tk_CanvasTextInfo *
    Tk_CanvasGetTextInfo(canvas)

# ARGUMENTS

A token that identifies a particular canvas widget.

# DESCRIPTION

Textual canvas items are somewhat more complicated to manage than other
items, due to things like the selection and the input focus.
**Tk_CanvasGetTextInfo** may be invoked by a type manager to obtain
additional information needed for items that display text. The return
value from **Tk_CanvasGetTextInfo** is a pointer to a structure that is
shared between Tk and all the items that display text. The structure has
the following form:

    typedef struct Tk_CanvasTextInfo {
        Tk_3DBorder selBorder;
        int selBorderWidth;
        XColor *selFgColorPtr;
        Tk_Item *selItemPtr;
        int selectFirst;
        int selectLast;
        Tk_Item *anchorItemPtr;
        int selectAnchor;
        Tk_3DBorder insertBorder;
        int insertWidth;
        int insertBorderWidth;
        Tk_Item *focusItemPtr;
        int gotFocus;
        int cursorOn;
    } Tk_CanvasTextInfo;

The **selBorder** field identifies a Tk_3DBorder that should be used for
drawing the background under selected text. *selBorderWidth* gives the
width of the raised border around selected text, in pixels.
*selFgColorPtr* points to an XColor that describes the foreground color
to be used when drawing selected text. *selItemPtr* points to the item
that is currently selected, or NULL if there is no item selected or if
the canvas does not have the selection. *selectFirst* and *selectLast*
give the indices of the first and last selected characters in
*selItemPtr*, as returned by the *indexProc* for that item.
*anchorItemPtr* points to the item that currently has the selection
anchor; this is not necessarily the same as *selItemPtr*. *selectAnchor*
is an index that identifies the anchor position within *anchorItemPtr*.
*insertBorder* contains a Tk_3DBorder to use when drawing the insertion
cursor; *insertWidth* gives the total width of the insertion cursor in
pixels, and *insertBorderWidth* gives the width of the raised border
around the insertion cursor. *focusItemPtr* identifies the item that
currently has the input focus, or NULL if there is no such item.
*gotFocus* is 1 if the canvas widget has the input focus and 0
otherwise. *cursorOn* is 1 if the insertion cursor should be drawn in
*focusItemPtr* and 0 if it should not be drawn; this field is toggled on
and off by Tk to make the cursor blink.

The structure returned by **Tk_CanvasGetTextInfo** is shared between Tk
and the type managers; typically the type manager calls
**Tk_CanvasGetTextInfo** once when an item is created and then saves the
pointer in the item\'s record. Tk will update information in the
Tk_CanvasTextInfo; for example, a **configure** widget command might
change the *selBorder* field, or a **select** widget command might
change the *selectFirst* field, or Tk might change *cursorOn* in order
to make the insertion cursor flash on and off during successive
redisplays.

Type managers should treat all of the fields of the Tk_CanvasTextInfo
structure as read-only, except for *selItemPtr*, *selectFirst*,
*selectLast*, and *selectAnchor*. Type managers may change
*selectFirst*, *selectLast*, and *selectAnchor* to adjust for insertions
and deletions in the item (but only if the item is the current owner of
the selection or anchor, as determined by *selItemPtr* or
*anchorItemPtr*). If all of the selected text in the item is deleted,
the item should set *selItemPtr* to NULL to indicate that there is no
longer a selection.

# KEYWORDS

canvas, focus, insertion cursor, selection, selection anchor, text
