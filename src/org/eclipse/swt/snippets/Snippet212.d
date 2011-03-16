/*******************************************************************************
 * Copyright (c) 2000, 2004 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     yidabu at gmail dot com  ( D China http://www.d-programming-language-china.org/ )
 *******************************************************************************/
/*
Unhandled Exception: EXCEPTION_ACCESS_VIOLATION(0xc0000005) at ntdll.dll (0x7c90316c) thread(1480)
->us
#0 ?? () at org.eclipse.swt\graphics\TextLayout.d:2915 from ntdll.dll
#1 0x77f205bf in ?? () at org.eclipse.swt\graphics\TextLayout.d:2915 from GDI32.dll
#2 0x00483c72 in  org.eclipse.swt.graphics.TextLayout.TextLayout.shape () at dwt\graphics\TextLayout.d:2915
#3 0x0047bfff in  org.eclipse.swt.graphics.TextLayout.TextLayout.computeRuns () at dwt\graphics\TextLayout.d:267
#4 0x00480474 in  org.eclipse.swt.graphics.Rectangle.Rectangle dwt.graphics.TextLayout.TextLayout.getBounds () at dwt\graphics\TextLayout.d:1387
#5 0x00411ea7 in  org.eclipse.swt.graphics.Point.Point dwt.custom.StyledText.StyledText.computeSize () at dwt\custom\StyledText.d:1784
#6 0x0041f24b in  org.eclipse.swt.layout.GridData.GridData.computeSize () at dwt\layout\GridData.d:484
#7 0x0043258f in  org.eclipse.swt.graphics.Point.Point dwt.layout.GridLayout.GridLayout.layout () at dwt\layout\GridLayout.d:232
#8 0x00432325 in  org.eclipse.swt.layout.GridLayout.GridLayout.layout () at dwt\layout\GridLayout.d:208
#9 0x004999af in  org.eclipse.swt.widgets.Composite.Composite.updateLayout () at dwt\widgets\Composite.d:1170
#10 0x00498eba in  org.eclipse.swt.widgets.Composite.Composite.sendResize () at dwt\widgets\Composite.d:879
#11 0x00499053 in  org.eclipse.swt.widgets.Composite.Composite.setBounds () at dwt\widgets\Composite.d:924
#12 0x004d959d in  org.eclipse.swt.widgets.Decorations.Decorations.setBounds () at dwt\widgets\Decorations.d:888
#13 0x0042f9a2 in  org.eclipse.swt.widgets.Shell.Shell.setBounds () at dwt\widgets\Shell.d:1460
#14 0x004733f3 in  org.eclipse.swt.widgets.Control.Control.setBounds () at dwt\widgets\Control.d:2639
#15 0x00473d27 in  org.eclipse.swt.widgets.Control.Control.setSize () at dwt\widgets\Control.d:3153
#16 0x004042c8 in _Dmain () at Snippet212.d:171
#17 0x00645778 in extern (C) int dmain2.main(int, char**) . void runMain(void*) () from dmain2
#18 0x006457af in extern (C) int dmain2.main(int, char**) . void runAll(void*) () from dmain2
#19 0x006454f0 in _main () from dmain2
#20 0x0065f801 in _mainCRTStartup () from constart
#21 0x7c816fd7 in ?? () from KERNEL32.dll
*/
module org.eclipse.swt.snippets.Snippet212;
/**
 * StyledText snippet: embed images
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 * 
 * @since 3.2
 */

import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.StyledText;
import org.eclipse.swt.custom.StyleRange;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.FileDialog;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.custom.PaintObjectEvent;
import org.eclipse.swt.custom.PaintObjectListener;
import org.eclipse.swt.events.VerifyEvent;
import org.eclipse.swt.events.VerifyListener;
import org.eclipse.swt.graphics.FontData;
import org.eclipse.swt.graphics.Font;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.graphics.GC;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.graphics.GlyphMetrics;
import java.lang.all;

const String OBJ_MARKER = "\uFFFC";

void main() {
    static StyledText styledText;
    static String text = 
        "This snippet shows how to embed images in a StyledText.\n"
        "Here is one: " ~ OBJ_MARKER ~ ", and here is another: " ~ OBJ_MARKER ~ "."
        "Use the add button to add an image from your filesystem to the StyledText at the current caret offset.";
    static Image[] images;
    static int[] offsets;

    static void addImage(Image image, int offset) {
        StyleRange style = new StyleRange ();
        style.start = offset;
        style.length = OBJ_MARKER.length;
        Rectangle rect = image.getBounds();
        style.metrics = new GlyphMetrics(rect.height, 0, rect.width);
        styledText.setStyleRange(style);        
    }

    Display display = new Display();
    Shell shell = new Shell(display);
    shell.setLayout(new GridLayout());
    styledText = new StyledText(shell, SWT.WRAP | SWT.BORDER);
    styledText.setLayoutData(new GridData(SWT.FILL, SWT.FILL, true, true));
    styledText.setText(text);
    images = [
        display.getSystemImage(SWT.ICON_QUESTION),
        display.getSystemImage(SWT.ICON_INFORMATION)
    ];
    offsets = new int[images.length];
    int lastOffset = 0;
    for (int i = 0; i < images.length; i++) {
        int offset = text.indexOf(OBJ_MARKER, lastOffset);
        offsets[i] = offset;
        addImage(images[i], offset);
        lastOffset = offset + 1;
    }
    
    void onVerify(Event e) {
        int start = e.start;
        int replaceCharCount = e.end - e.start;
        int newCharCount = e.text.length;
        for (int i = 0; i < offsets.length; i++) {
            int offset = offsets[i];
            if (start <= offset && offset < start + replaceCharCount) {
                // this image is being deleted from the text
                if (images[i] !is null && !images[i].isDisposed()) {
                    images[i].dispose();
                    images[i] = null;
                }
                offset = -1;
            }
            if (offset != -1 && offset >= start) offset += newCharCount - replaceCharCount;
            offsets[i] = offset;
        }
    }    
    // use a verify listener to keep the offsets up to date
    styledText.addListener(SWT.Verify, dgListener(&onVerify));

    styledText.addPaintObjectListener(new class(images, offsets) PaintObjectListener {
        Image[] images;
        int[] offsets;
        this( Image[] images_, int[] offsets_) {
            this.images = images_;
            this.offsets = offsets_;
        }
        public void paintObject(PaintObjectEvent event) {
            GC gc = event.gc;
            StyleRange style = event.style;
            int start = style.start;
            for (int i = 0; i < offsets.length; i++) {
                int offset = offsets[i];
                if (start == offset) {
                    Image image = images[i];
                    int x = event.x;
                    int y = event.y + event.ascent - style.metrics.ascent;						
                    gc.drawImage(image, x, y);
                }
            }
        }
    });    
    
    Button button = new Button (shell, SWT.PUSH);
    button.setText("Add Image");
    button.setLayoutData(new GridData(SWT.CENTER, SWT.CENTER, false, false));
    
    void onSelection(Event e) {
       FileDialog dialog = new FileDialog(shell);
        String filename = dialog.open();
        if (filename !is null) {
            try {
                Image image = new Image(display, filename);
                int offset = styledText.getCaretOffset();
                styledText.replaceTextRange(offset, 0, OBJ_MARKER);
                int index = 0;
                while (index < offsets.length) {
                    if (offsets[index] == -1 && images[index] is null) break;
                    index++;
                }
                if (index == offsets.length) {
                    int[] tmpOffsets = new int[index + 1];
                    System.arraycopy(offsets, 0, tmpOffsets, 0, offsets.length);
                    offsets = tmpOffsets;
                    Image[] tmpImages = new Image[index + 1];
                    System.arraycopy(images, 0, tmpImages, 0, images.length);
                    images = tmpImages;
                }
                offsets[index] = offset;
                images[index] = image;
                addImage(image, offset);
            } catch (Exception e) {
                ExceptionPrintStackTrace(e);
            }
        }
    }
    button.addListener(SWT.Selection, dgListener(&onSelection));
    shell.setSize(400, 400);
    shell.open();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch())
            display.sleep();
    }
    for (int i = 0; i < images.length; i++) {
        Image image = images[i];
        if (image !is null && !image.isDisposed()) {
            image.dispose();
        }
    }
    display.dispose();

}

