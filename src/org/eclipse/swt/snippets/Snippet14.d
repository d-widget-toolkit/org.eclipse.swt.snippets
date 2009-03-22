/*******************************************************************************
 * Copyright (c) 2000, 2004 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * D Port:
 *     Thomas Demmer <t_demmer AT web DOT de>
 *******************************************************************************/
module org.eclipse.swt.snippets.Snippet14;

/*
 * Control example snippet: detect mouse enter, exit and hover events
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Shell;

import java.lang.all;

import tango.io.Stdout;

void main (String [] args) {
    Display display = new Display ();
    Shell shell = new Shell (display);
    shell.setSize (100, 100);
    shell.addListener (SWT.MouseEnter, new class() Listener{
        public void handleEvent (Event e) {
            Stdout("ENTER\n");
            Stdout.flush();
        }
    });
    shell.addListener (SWT.MouseExit, new class() Listener{
        public void handleEvent (Event e) {
            Stdout("EXIT\n");
            Stdout.flush();
        }
    });
    shell.addListener (SWT.MouseHover, new class() Listener{
        public void handleEvent (Event e) {
            Stdout("HOVER\n");
            Stdout.flush();
        }
    });
    shell.open ();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}
