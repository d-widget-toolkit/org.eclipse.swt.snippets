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
module org.eclipse.swt.snippets.Snippet39;

/*
 * CCombo example snippet: create a CCombo
 *
 * For a list of all SWT example snippets see
 * http://www.eclipse.org/swt/snippets/
 */
import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.CCombo;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionListener;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;

import java.lang.all;
import tango.util.Convert;
import tango.io.Stdout;
public static void main(String[] args) {
    Display display = new Display();
    Shell shell = new Shell(display);
    shell.setLayout(new GridLayout());

    CCombo combo = new CCombo(shell, SWT.FLAT | SWT.BORDER);
    combo.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false));
    for (int i = 0; i < 5; i++) {
        combo.add("item" ~ to!(char[])(i));
    }
    combo.setText("item0");

    combo.addSelectionListener(new class() SelectionAdapter {
        public void widgetSelected(SelectionEvent e) {
            Stdout.formatln("Item selected");
        };
    });

    shell.pack();
    shell.open();
    while (!shell.isDisposed()) {
        if (!display.readAndDispatch()) display.sleep();
    }
}
