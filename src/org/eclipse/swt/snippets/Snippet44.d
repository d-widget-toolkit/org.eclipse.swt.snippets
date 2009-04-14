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
module org.eclipse.swt.snippets.Snippet44;

/*
 * Cursor example snippet: set the hand cursor into a control
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Cursor;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Shell;

import java.lang.all;

import org.eclipse.core.runtime.jobs.Job;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.runtime.jobs.IJobChangeListener;
import tango.io.Stdout;

class MyJob : Job {
    this(char[] name) {
        super(name);
    }
    public IStatus run(IProgressMonitor monitor) {
        Stdout.formatln("doing job");
        return Status.OK_STATUS;
    }
}


void main (String [] args) {
    Display display = new Display ();
    Cursor cursor = new Cursor (display, SWT.CURSOR_HAND);
    Shell shell = new Shell (display);
    shell.open ();
    Button b = new Button (shell, 0);
    b.setBounds (10, 10, 200, 200);
    b.addListener (SWT.Selection, new class() Listener{
        public void handleEvent (Event e) {
            //b.setCursor (cursor);
            auto job = new MyJob("test");
            job.schedule();
            job.join;
            Stdout.formatln("job done");
        }
    });
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    cursor.dispose ();
    display.dispose ();
}

