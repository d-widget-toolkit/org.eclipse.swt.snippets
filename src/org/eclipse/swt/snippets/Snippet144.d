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
 *     Jesse Phillips <Jesse.K.Phillips+D> gmail.com
 *******************************************************************************/
module org.eclipse.swt.snippets.Snippet144;

/*
 * Virtual Table example snippet: create a table with 1,000,000 items (lazy)
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 *
 * @since 3.0
 */
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Table;
import org.eclipse.swt.widgets.TableItem;
import org.eclipse.swt.layout.RowLayout;
import org.eclipse.swt.layout.RowData;

import tango.io.Stdout;
import tango.time.StopWatch;
import tango.util.Convert;

const int COUNT = 1000000;

void main() {
    auto display = new Display ();
    auto shell = new Shell (display);
    shell.setLayout (new RowLayout (SWT.VERTICAL));
    auto table = new Table (shell, SWT.VIRTUAL | DWT.BORDER);
    table.addListener (SWT.SetData, new class Listener {
        public void handleEvent (Event event) {
            auto item = cast(TableItem) event.item;
            auto index = table.indexOf (item);
            item.setText ("Item " ~ to!(char[])(index));
            Stdout(item.getText ()).newline;
        }
    });
    table.setLayoutData (new RowData (200, 200));
    auto button = new Button (shell, SWT.PUSH);
    button.setText ("Add Items");
    auto label = new Label(shell, SWT.NONE);
    button.addListener (SWT.Selection, new class Listener {
        public void handleEvent (Event event) {
            StopWatch elapsed;
            elapsed.start;
            table.setItemCount (COUNT);
            auto t = elapsed.stop;
            label.setText ("Items: " ~ to!(char[])(COUNT) ~
                           ", Time: " ~ to!(char[])(t) ~ " (sec)");
            shell.layout ();
        }
    });
    shell.pack ();
    shell.open ();
    while (!shell.isDisposed ()) {
        if (!display.readAndDispatch ()) display.sleep ();
    }
    display.dispose ();
}
