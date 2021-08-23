// copyright (c) 2020-2021 hors<horsicq@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
#include "guimainwindow.h"
#include "ui_guimainwindow.h"

GuiMainWindow::GuiMainWindow(QWidget *pParent) :
    QMainWindow(pParent),
    ui(new Ui::GuiMainWindow)
{
    ui->setupUi(this);

    g_pFile=nullptr;

    setWindowTitle(QString("%1 v%2").arg(X_APPLICATIONDISPLAYNAME,X_APPLICATIONVERSION));

    setAcceptDrops(true);

#ifdef QT_DEBUG
    ui->labelLogo->hide();
#endif

    g_xOptions.setName(X_OPTIONSFILE);

    QList<XOptions::ID> listIDs;

    listIDs.append(XOptions::ID_STYLE);
    listIDs.append(XOptions::ID_QSS);
    listIDs.append(XOptions::ID_LANG);
    listIDs.append(XOptions::ID_STAYONTOP);
    listIDs.append(XOptions::ID_SAVELASTDIRECTORY);
    listIDs.append(XOptions::ID_SAVEBACKUP);
    listIDs.append(XOptions::ID_SEARCHSIGNATURESPATH);

    g_xOptions.setValueIDs(listIDs);
    g_xOptions.load();

    g_xShortcuts.setName(X_SHORTCUTSFILE);

    g_xShortcuts.addGroup(XShortcuts::ID_STRINGS);
    g_xShortcuts.addGroup(XShortcuts::ID_SIGNATURES);
    g_xShortcuts.addGroup(XShortcuts::ID_HEX);
    g_xShortcuts.addGroup(XShortcuts::ID_DISASM);

    g_xShortcuts.load();

    adjust();

    if(QCoreApplication::arguments().count()>1)
    {
        QString sFileName=QCoreApplication::arguments().at(1);

        processFile(sFileName);
    }
}

GuiMainWindow::~GuiMainWindow()
{
    closeCurrentFile();
    g_xOptions.save();
    g_xShortcuts.save();

    delete ui;
}

void GuiMainWindow::on_actionOpen_triggered()
{
    QString sDirectory=g_xOptions.getLastDirectory();

    QString sFileName=QFileDialog::getOpenFileName(this,tr("Open file")+QString("..."),sDirectory,tr("All files")+QString(" (*)"));

    if(!sFileName.isEmpty())
    {
        processFile(sFileName);
    }
}

void GuiMainWindow::on_actionClose_triggered()
{
    closeCurrentFile();
}

void GuiMainWindow::on_actionExit_triggered()
{
    this->close();
}

void GuiMainWindow::on_actionOptions_triggered()
{
    DialogOptions dialogOptions(this,&g_xOptions);
    dialogOptions.exec();

    adjust();
}

void GuiMainWindow::on_actionAbout_triggered()
{
    DialogAbout dialogAbout(this);
    dialogAbout.exec();
}

void GuiMainWindow::adjust()
{
    g_xOptions.adjustStayOnTop(this);

    g_formatOptions.bSaveBackup=g_xOptions.isSaveBackup();

    ui->widgetViewer->setShortcuts(&g_xShortcuts);
}

void GuiMainWindow::processFile(QString sFileName)
{
    if((sFileName!="")&&(QFileInfo(sFileName).isFile()))
    {
        g_xOptions.setLastDirectory(QFileInfo(sFileName).absolutePath());

        closeCurrentFile();

        g_pFile=new QFile;

        g_pFile->setFileName(sFileName);

        if(!g_pFile->open(QIODevice::ReadWrite))
        {
            if(!g_pFile->open(QIODevice::ReadOnly))
            {
                closeCurrentFile();
            }
        }

        if(g_pFile)
        {
            XPE pe(g_pFile);
            if(pe.isValid())
            {
                ui->stackedWidgetMain->setCurrentIndex(1);
                g_formatOptions.bIsImage=false;
                g_formatOptions.nImageBase=-1;
                g_formatOptions.nStartType=SPE::TYPE_HEURISTICSCAN;
                g_formatOptions.sSearchSignaturesPath=g_xOptions.getSearchSignaturesPath();
                ui->widgetViewer->setData(g_pFile,g_formatOptions,0,0,0);

                ui->widgetViewer->reload();

                adjust();

                setWindowTitle(sFileName);
            }
            else
            {
                QMessageBox::critical(this,tr("Error"),tr("It is not a valid file"));
            }
        }
        else
        {
            QMessageBox::critical(this,tr("Error"),tr("Cannot open file"));
        }
    }
}

void GuiMainWindow::closeCurrentFile()
{
    ui->stackedWidgetMain->setCurrentIndex(0);

    if(g_pFile)
    {
        g_pFile->close();
        delete g_pFile;
        g_pFile=nullptr;
    }

    setWindowTitle(QString("%1 v%2").arg(X_APPLICATIONDISPLAYNAME,X_APPLICATIONVERSION));
}

void GuiMainWindow::dragEnterEvent(QDragEnterEvent *event)
{
    event->acceptProposedAction();
}

void GuiMainWindow::dragMoveEvent(QDragMoveEvent *event)
{
    event->acceptProposedAction();
}

void GuiMainWindow::dropEvent(QDropEvent *event)
{
    const QMimeData* mimeData=event->mimeData();

    if(mimeData->hasUrls())
    {
        QList<QUrl> urlList=mimeData->urls();

        if(urlList.count())
        {
            QString sFileName=urlList.at(0).toLocalFile();

            sFileName=XBinary::convertFileName(sFileName);

            processFile(sFileName);
        }
    }
}

void GuiMainWindow::on_actionShortcuts_triggered()
{
    DialogShortcuts dialogShortcuts(this);

    dialogShortcuts.setData(&g_xShortcuts);

    dialogShortcuts.exec();

    adjust();
}

void GuiMainWindow::on_actionDemangle_triggered()
{
    DialogDemangle dialogDemangle(this);

    dialogDemangle.exec();
}
