/* Copyright (c) 2020-2023 hors<horsicq@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
#ifndef GUIMAINWINDOW_H
#define GUIMAINWINDOW_H

#include <QDragEnterEvent>
#include <QFileDialog>
#include <QMainWindow>
#include <QMimeData>

#include "../global.h"
#include "dialogabout.h"
#include "dialogoptions.h"
#include "dialogshortcuts.h"
#include "pewidget.h"
#ifdef USE_YARA
#include "xyara.h"
#endif

namespace Ui {
class GuiMainWindow;
}

class GuiMainWindow : public QMainWindow {
    Q_OBJECT

public:
    explicit GuiMainWindow(QWidget *pParent = nullptr);
    ~GuiMainWindow();

private slots:
    void createMenus();
    void actionOpenSlot();
    void actionCloseSlot();
    void actionExitSlot();
    void actionDemangleSlot();
    void actionShortcutsSlot();
    void actionOptionsSlot();
    void actionAboutSlot();
    void adjustWindow();
    void processFile(QString sFileName);
    void closeCurrentFile();
    void updateShortcuts();

protected:
    void dragEnterEvent(QDragEnterEvent *pEvent) override;
    void dragMoveEvent(QDragMoveEvent *pEvent) override;
    void dropEvent(QDropEvent *pEvent) override;

private:
    Ui::GuiMainWindow *ui;
    XOptions g_xOptions;
    XShortcuts g_xShortcuts;
    FW_DEF::OPTIONS g_formatOptions;
    QFile *g_pFile;
    XInfoDB *g_pXInfo;
    QMenu *g_pMenuFile;
    QMenu *g_pMenuTools;
    QMenu *g_pMenuHelp;
    QAction *g_pActionOpen;
    QAction *g_pActionClose;
    QAction *g_pActionExit;
    QAction *g_pActionOptions;
    QAction *g_pActionAbout;
    QAction *g_pActionShortcuts;
    QAction *g_pActionDemangle;
};

#endif  // GUIMAINWINDOW_H
