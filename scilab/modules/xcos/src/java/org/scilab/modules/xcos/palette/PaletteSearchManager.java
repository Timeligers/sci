/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2015 - Marcos CARDINOT
 * Copyright (C) 2017 - Scilab Enterprises - Clement DAVID
 *
 * This file must be used under the terms of the CeCILL.
 * This source file is licensed as described in the file COPYING, which
 * you should have received as part of this distribution.  The terms
 * are also available at
 * https://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt
 *
 */

package org.scilab.modules.xcos.palette;

import java.io.File;
import java.io.IOException;
import static java.util.Comparator.reverseOrder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import static java.util.Map.Entry.comparingByValue;
import java.util.logging.Level;
import java.util.logging.Logger;
import static java.util.stream.Collectors.counting;
import static java.util.stream.Collectors.groupingBy;
import static java.util.stream.Collectors.toList;

import javax.swing.JScrollPane;
import javax.swing.tree.TreeModel;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.index.IndexWriterConfig.OpenMode;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.ByteBuffersDirectory;
import org.scilab.modules.xcos.palette.model.PaletteBlock;
import org.scilab.modules.xcos.palette.model.PaletteNode;
import org.scilab.modules.xcos.palette.model.PreLoaded;
import org.scilab.modules.xcos.palette.view.PaletteManagerPanel;
import org.scilab.modules.xcos.palette.view.PaletteManagerView;
import org.scilab.modules.xcos.palette.view.PaletteSearchView;
import org.scilab.modules.xcos.utils.XcosMessages;

/**
 * Manager class for the palettes search.
 * @author Marcos Cardinot <mcardinot@gmail.com>
 */
public final class PaletteSearchManager {

    private Boolean indexIsOutdated = true;

    private Analyzer analyzer;
    private IndexWriter writer;
    private Directory indexedDirectory;
    private PaletteIndexer paletteIndexer;
    private PaletteSearcher paletteSearcher;
    private PaletteSearchView view;
    private Map<String, PaletteBlock> nameToPalette;

    /** Default constructor */
    public PaletteSearchManager() {
        try {
            indexedDirectory = new ByteBuffersDirectory();
            analyzer = new StandardAnalyzer();
            IndexWriterConfig config = new IndexWriterConfig(analyzer);
            config.setOpenMode(OpenMode.CREATE);
            writer = new IndexWriter(indexedDirectory, config);
        } catch (IOException ex) {
            Logger.getLogger(PaletteSearchManager.class.getName()).log(Level.SEVERE, null, ex);
        }

        nameToPalette = new HashMap<>();
        view = new PaletteSearchView();
        paletteIndexer = new PaletteIndexer(this);
        paletteSearcher = new PaletteSearcher(this);
    }

    /**
     * Look for a block into the Index.
     * @param query Query
     */
    public void search(String query) {
        PaletteManagerView.get().getTree().clearSelection();
        view.initComponents();

        final String queryLabel = "'" + query + "' - ";
        view.setText(queryLabel + XcosMessages.SEARCHING);

        PaletteManagerPanel panel = PaletteManagerView.get().getPanel();
        JScrollPane scrollPane = (JScrollPane) panel.getRightComponent();
        scrollPane.setViewportView(view);

        if (indexIsOutdated) {
            refreshIndex();
            indexIsOutdated = false;
        }

        List<Document> found = paletteSearcher.search(query.toLowerCase());
        // sort results per maximum frequency of the block name
        Map<String, Long> freq = found.stream()
                .map(doc -> doc.get("refname"))
                .collect(groupingBy(x->x, counting()));
        List<String> foundNames = freq.entrySet()
                .stream()
                .sorted(comparingByValue(reverseOrder()))
                .map(Map.Entry::getKey)
                .collect(toList());
        
        for (String b : foundNames) {
            PaletteBlock block = nameToPalette.get(b);
            if (block != null) {
                view.addBlock(block);
            }
        }
        view.setText(queryLabel + foundNames.size() + " " + XcosMessages.MATCHES);
        view.revalidate();
        scrollPane.revalidate();
    }

    /**
     * Refreshes the whole Index
     */
    private void refreshIndex() {
        TreeModel model = PaletteManagerView.get().getTree().getModel();
        if (model != null) {
            loadHashTable(model, model.getRoot(), "");
            paletteIndexer.createIndex(nameToPalette);
        }
    }

    /**
     * Recursive function that loads a hashtable containing all available blocks.
     * @param model TreeModel
     * @param obj Object
     * @param treePath String
     */
    private void loadHashTable(TreeModel model, Object obj, String treePath) {
        int  cc = model.getChildCount(obj);
        for (int i = 0; i < cc; ++i) {
            PaletteNode node = (PaletteNode) model.getChild(obj, i);
            if (node instanceof PreLoaded) {
                for (PaletteBlock b : ((PreLoaded) node).getBlock()) {
                    nameToPalette.put(b.getName(), b);
                }
            } else {
                loadHashTable(model, node, treePath + File.separator + node.toString());
            }
        }
    }

    /**
     * When the Index is outdated, the PaletteSearchManager
     * will refresh it before the next search().
     * @param b True if it is outdated.
     */
    public void setIndexIsOutdated(Boolean b) {
        indexIsOutdated = b;
    }

    /**
     * Get analyzer
     * @return Analyzer
     */
    public Analyzer getAnalyzer() {
        return analyzer;
    }

    /**
     * Get IndexWriter
     * @return IndexWriter
     */
    public IndexWriter getIndexWriter() {
        return writer;
    }

    /**
     * Get the current indexed directory.
     * @return Directory
     */
    public Directory getDirectory() {
        return indexedDirectory;
    }
}
