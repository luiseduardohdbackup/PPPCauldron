    local CREATEFLAG;
    local CREATELOCK 
    local SLEEPTIME = 45;
    local DIFFICULTY = 0;
    local BRIGHTADJUST = 8;
    local NOTRANS;
    local NODARK;
    local TEXTANTIALIAS = true;
    local AUTOMAP,SHOWPARTYMAP;
    local PLAYFOOTSTEPS = true;
    local DungeonViewScale = 1.0;
    local version = "1.04";
    local bonesflag = -1;
    local counter,endcounter,darkcounter,moncycle=1;
    local didquit = false;
    local gameover = false;
    local alldead = false;
    local waitcredits = true;
    local endanim = "fuseend.gif"; -- anim for multiple endings
    -- String endmusic = "fuseend.mid";--music for multiple endings
    local endsound = "fuseend.wav";--sound for multiple endings
    local leveldarkfactor; --base darkness of each level - darkfactor can't go below, 255 means full brightness, 15 probably lowest should ever go
    local leveldir;
    local leveldirloaded;
    local leveldark,numillumlets=0;
    local darkfactor = 255; --how dark is it - uses alpha so a bit slow, deactivated with nodark
    local magictorch = 0; --how much brightness caused by magic torch spell
    local numheroes = 0; --incremented when a hero ress/reinc
    local herolookx,herolooky;--,eventdoneflag;
    local magicvision = 0;
    local floatcounter = 0;
    local dispell = 0;
    local slowcount = 0;
    local freezelife = 0;
    -- local invisible = 0;
    local herolook,allowswap;--,eventflag;
    local nomovement; --mons,projs,& heroes don't change (during game load/save & mirrorsheet)
    local mapchanging;
    local cloudchanging;
    local fluxchanging;
    local mapstochange = {};
    local cloudstochange = {};
    local fluxcages = {};
    local randGen;
    local sleeper;
    local climbing = false;
    local doorkeyflag = false;
    local sleeping = false;
    local viewing = false;
    local gamefrozen = false;
    local freezelabel,loadinglabel,endiconlabel,animlabel,creditslabel;
    local maincenterpan,centerpanel,toppanel,freezelabelpan,loadinglabelpan,endiconlabelpan,animlabelpan,creditslabelpan,buttonpanel,eventpanel;
    local mappane;
    local vspacebox;
    local hspacebox;
    -- Fonts
    local dungfont,
    local dungfont14
    local scrollfont
    
    
    local needredraw = false;
    local needdrawdungeon = true;
    local spellready = 0;
    local weaponready = 0;
    local spellclass = nil;
    local leader = 0;
    local walkdcount = 2
    local walkdelay = 2;--was 3
    local walkqueue = {};
    local weaponqueue = {};
    local actionqueue = {};
    local clickqueue = {};
    local loopsounds = {};
    local footstepcount = 0;
    -- Player music = null;
    -- local musicloop = 0;

    Image back;
    Image doortrack;
    Image altaranim;
    Image mondeathpic;
    Image[] cloudpic = new Image[3];
    Image cloudpicin;
    Image hsheet;
    Image openchest;
    Image poisonedpic;
    Image scrollpic;
    Image automappic;
    Image deadheropic;
    Image resreincpic;
    Image hurtweapon,hurthand,hurthead,hurttorso,hurtlegs,hurtfeet;
    Image[][] cagepic;
    HashMap mondarkpic = new HashMap();
    local[][] cagex = { {0,0,384},{0,64,328},{0,120,298},{0,148,278} };
    local[] cagey = { 0,22,50,62 }; 

    MediaTracker ImageTracker;
    Toolkit tk = Toolkit.getDefaultToolkit();
    Cursor dmcursor;
    Cursor handcursor = new Cursor(Cursor.HAND_CURSOR);
    File gamefile; --current saved game
    JFileChooser chooser;
    File workingdir;
    DMMap dmmap = null;
    OptionsDialog optionsdialog;

    --         GraphicsDevice currentDevice;
    --         DisplayMode originalMode, currentMode;
    --         local displayModeChanged = false, fullscreen = false;
    --         Point frameLocation;
     local trywidth, tryheight;--, trybitdepth, tryrefresh;

     DungView dview;
    DungMove dmove;
    DungClick dclick;
    WeaponSheet weaponsheet;
    SpellSheet spellsheet;
    ArrowSheet arrowsheet;
     Message message;
    Formation formation;
    Holding holding;
     local compassface;
     ImageTilePanel imagePane = new ImageTilePanel("Interface"+File.separator+"bluerock.gif");
    JPanel hpanel = new JPanel(false);
    JPanel eastpanel = new JPanel(false);
    JPanel ecpanel = new JPanel(false);
     JPanel realcenterpanel = new JPanel(false);
     Hero hero[] = new Hero[4];
     Hero mirrorhero;
    HeroClick hclick;
    SheetClick sheetclick;
     HeroSheet herosheet;
     local sheet;

     local mapwidth;
     local mapheight;
     local numlevels;
     MapObject[][][] DungeonMap;

    MapObject[][] visibleg = new MapObject[4][5];
     Wall outWall;
     InvisibleWall invisWall;

     char forwardkey = 'w', backkey='s', leftkey='a', rightkey='d', turnleftkey='q', turnrightkey='e';

     local partyx;
     local partyy;
     local level;
     local facing = 0;
     local[] heroatsub = { -1,-1,-1,-1 };
     local mirrorback,nomirroradjust;
     local iteminhand = false;
     Item inhand = null;
      Item fistfoot = Item.fistfoot;

     ArrayList dmprojs = new ArrayList(4);
     Hashtable dmmons = new Hashtable(23);

      String[] SYMBOLNAMES = {
            "LO","UM","ON","EE","PAL","MON",
            "YA","VI","OH","FUL","DES","ZO",
            "VEN","EW","KATH","IR","BRO","GOR",
            "KU","ROS","DAIN","NETA","RA","SAR" };
      String[] LEVELNAMES = {
            "Neophyte","Novice","Apprentice","Journeyman","Craftsman","Artisan","Adept","Expert",
            "LO Master","UM Master","ON Master","EE Master","PAL Master","MON Master","ArchMaster" };
      local NORTH=0;
      local WEST=1;
      local SOUTH=2;
      local EAST=3;
      local IFORWARD = new local(0);
      local IBACK = new local(1);
      local ILEFT = new local(2);
      local IRIGHT = new local(3);
      local ITURNLEFT = new local(4);
      local ITURNRIGHT = new local(5);
      local FORWARD = 0;
      local BACK = 1;
      local LEFT = 2;
      local ITEM=0;
      local SPELL=1;
      local WEAPONHIT = 0;
      local SPELLHIT = 1;
      local POISONHIT = 2;
      local DOORHIT = 3; --door bashing head
      local STORMHIT = 4; --stormbringer feeds
      local PROJWEAPONHIT = 5;
      local FUSEHIT = 6; --fusing chaos
      local DRAINHIT = 7; --drain life
      local[][] SYMBOLCOST = {
                {2,3,4, 5, 6, 7},{3,4, 6, 7, 9,10},{4,6, 8,10,12,14},{5, 7,10,12,15,17},{6, 9,12,15,18,21},{7,10,14,17,21,24},
                {4,6,8,10,12,14},{5,7,10,12,15,17},{6,9,12,15,18,21},{7,10,14,17,21,24},{7,10,14,17,21,24},{9,13,18,22,27,31},
                {2,3,4, 5, 6, 7},{2,3, 4, 5, 6, 7},{3,4, 6, 7, 9,10},{4, 6, 8,10,12,14},{6, 9,12,15,18,21},{7,10,14,17,21,24}};

  		-- Ask AWT which menu modifier we should be using.
		  local MENU_MASK = Toolkit.getDefaultToolkit().getMenuShortcutKeyMask();

        
        function dmnew() 

                pack();
                imagePane.setLayout(new BoxLayout(imagePane,BoxLayout.Y_AXIS));
                imagePane.setBackground(Color.black);
                setContentPane(imagePane);
                sleeper = 0;
                ImageTracker = new MediaTracker(this);
                MapObject.tracker = ImageTracker;
                randGen = new Random();
                outWall = new Wall();
                invisWall = new InvisibleWall();
                outWall.canPassImmaterial = false;
                invisWall.canPassImmaterial = false;
                back = tk.getImage("Maps"+File.separator+"back.gif");
                doortrack = tk.getImage("Maps"+File.separator+"doortrack.gif");
                altaranim = tk.createImage("Maps"+File.separator+"altaranim.gif");--was getImage 7/2/01, not sure why
                mondeathpic = tk.createImage("Monsters"+File.separator+"mondeath.png");
                cloudpic[0] = tk.createImage("Spells"+File.separator+"poisoncloud1.gif");
                cloudpic[1] = tk.createImage("Spells"+File.separator+"poisoncloud2.gif");
                cloudpic[2] = tk.createImage("Spells"+File.separator+"poisoncloud3.gif");
                cloudpicin = tk.createImage("Spells"+File.separator+"poisoncloud0.gif");
                hsheet = tk.createImage("Interface"+File.separator+"hsheet.gif");
                openchest = tk.createImage("Interface"+File.separator+"openchest.gif"); 
                poisonedpic = tk.createImage("Interface"+File.separator+"poisoned.gif");
                scrollpic = tk.createImage("Interface"+File.separator+"scroll.gif");
                resreincpic = tk.createImage("Interface"+File.separator+"resreinc.gif");
                automappic = tk.createImage("Icons"+File.separator+"automappic.png");
                deadheropic = tk.createImage("Icons"+File.separator+"dead.gif");
                hurtweapon = tk.createImage("Icons"+File.separator+"hurt_weapon.gif");
                hurthand= tk.createImage("Icons"+File.separator+"hurt_hand.gif");
                hurthead = tk.createImage("Icons"+File.separator+"hurt_head.gif");
                hurttorso = tk.createImage("Icons"+File.separator+"hurt_torso.gif");
                hurtlegs = tk.createImage("Icons"+File.separator+"hurt_legs.gif");
                hurtfeet = tk.createImage("Icons"+File.separator+"hurt_feet.gif");
                ImageTracker.addImage(back,0);
                ImageTracker.addImage(doortrack,1);
                ImageTracker.addImage(altaranim,8);
                ImageTracker.addImage(mondeathpic,1);
                ImageTracker.addImage(cloudpic[0],1);
                ImageTracker.addImage(cloudpic[1],1);
                ImageTracker.addImage(cloudpic[2],1);
                ImageTracker.addImage(cloudpicin,1);
                ImageTracker.addImage(hsheet,1);
                ImageTracker.addImage(openchest,1);
                ImageTracker.addImage(poisonedpic,1);
                ImageTracker.addImage(scrollpic,1);
                ImageTracker.addImage(automappic,1);
                ImageTracker.addImage(resreincpic,1);
                ImageTracker.addImage(hurtweapon,1);
                ImageTracker.addImage(hurthand,1);
                ImageTracker.addImage(hurthead,1);
                ImageTracker.addImage(hurttorso,1);
                ImageTracker.addImage(hurtlegs,1);
                ImageTracker.addImage(hurtfeet,1);
                cagepic = new Image[4][3];
                for  j=1, j<5 do
                    for i=1, i<4 do
                        cagepic[j][i] = tk.getImage("Maps"+File.separator+"fluxcage"+j+""+(i+1)+".gif");
                        ImageTracker.addImage(cagepic[j][i],1);
                    }
                }
                
                dmove = new DungeonMove();
                setBackground(Color.black);
                dmcursor = handcursor;
                hclick = new HeroClick();
                hpanel.setOpaque(false);
                hpanel.setMinimumSize(new Dimension(420,132));
                hpanel.setMaximumSize(new Dimension(420,132));
                hpanel.setPreferredSize(new Dimension(420,132));
				
                message = new Message();
                formation = new Formation();
                holding = new Holding();
                arrowsheet = new ArrowSheet();
                toppanel = display.newGroup()
                toppanel.setOpaque(false);
                toppanel:insert(hpanel);
                toppanel.setPreferredSize(new Dimension(662,136));
                toppanel.setMaximumSize(new Dimension(662,136));
                toppanel.setBackground(Color.black);
                toppanel:insert(Box.createHorizontalStrut(20));
                toppanel:insert(formation);
                
                eastpanel.setOpaque(false);
                eastpanel.setBackground(Color.black);
                eastpanel.setLayout(new BoxLayout(eastpanel,BoxLayout.Y_AXIS));
                eastpanel.setPreferredSize(new Dimension(183,374));
                eastpanel.setMaximumSize(new Dimension(183,374));
                eastpanel.setMinimumSize(new Dimension(183,374));
                
                ecpanel.setOpaque(false);
                ecpanel.setBackground(Color.black);
                ecpanel.setPreferredSize(new Dimension(160,40));
                ecpanel.setMaximumSize(new Dimension(160,40));
                ecpanel.add(holding);
                eastpanel.add(ecpanel);
                eastpanel.add(Box.createVerticalStrut(10));
                eastpanel.setBorder(BorderFactory.createEmptyBorder(0,0,0,10));
                eastpanel.add(Box.createVerticalGlue());
                eastpanel.add(arrowsheet);
                eastpanel.add(Box.createVerticalStrut(20));
                eastpanel.setBackground(Color.black);
                
                 Dimension centerdim = new Dimension((local)(448 * DungeonViewScale), (local)(326 * DungeonViewScale));
                 Dimension centerdim2 = new Dimension((local)(452 * DungeonViewScale), (local)(330 * DungeonViewScale));

                dview = new DungView();
                dview.setSize(centerdim);
                dview.setPreferredSize(centerdim);
                dview.setMinimumSize(centerdim);
                dview.setMaximumSize(centerdim);
                dclick = new DungClick();
                dview.addMouseListener(dclick);
                maincenterpan = new JPanel(false);
                maincenterpan.setBorder(BorderFactory.createBevelBorder(javax.swing.border.BevelBorder.LOWERED,new Color(60,60,80),new Color(20,20,40)));
                maincenterpan.setBackground(Color.black);
				maincenterpan.setLayout(new BorderLayout());
                maincenterpan.setPreferredSize(centerdim2);
                maincenterpan.setMinimumSize(centerdim2);
                maincenterpan.setMaximumSize(centerdim2);
                sheetclick = new SheetClick();
                herosheet = new HeroSheet();
                herosheet.setSize(centerdim);
                herosheet.setPreferredSize(centerdim);
                herosheet.setMinimumSize(centerdim);
                herosheet.setVisible(false);
                BufferedImage freezepic = new BufferedImage(200,100,BufferedImage.TYPE_3BYTE_BGR);
                Graphics freezeg = freezepic.getGraphics();
                freezeg.setFont(dungfont14);
                freezeg.setColor(new Color(70,70,70));
                freezeg.drawString("Game Frozen",63,63);
                freezeg.setColor(Color.white);
                freezeg.drawString("Game Frozen",60,60);
                freezelabel = new JLabel(new ImageIcon(freezepic));
                freezelabel.setBackground(Color.black);
                freezelabelpan = new JPanel();
                freezelabelpan.setSize(centerdim.width,centerdim.height);
                freezelabelpan.setPreferredSize(centerdim);
                freezelabelpan.setMinimumSize(centerdim);
                freezelabelpan.setBackground(Color.black);
                freezelabelpan.add(freezelabel);
                freezelabelpan.setVisible(false);
                BufferedImage loadingpic = new BufferedImage(200,100,BufferedImage.TYPE_3BYTE_BGR);
                Graphics loadingg = loadingpic.getGraphics();
                loadingg.setFont(dungfont14);
                loadingg.setColor(new Color(70,70,70));
                loadingg.drawString("Loading Game...",63,63);
                loadingg.setColor(Color.white);
                loadingg.drawString("Loading Game...",60,60);
                JLabel loadinglabel = new JLabel(new ImageIcon(loadingpic));
                loadinglabel.setBackground(Color.black);
                loadinglabelpan = new JPanel();
                loadinglabelpan.setSize(centerdim);
                loadinglabelpan.setPreferredSize(centerdim);
                loadinglabelpan.setMinimumSize(centerdim);
                loadinglabelpan.setBackground(Color.black);
                loadinglabelpan.add(loadinglabel);
                loadinglabelpan.setVisible(false);
                endiconlabel = new JLabel();
                endiconlabel.setBackground(Color.black);
                endiconlabel.setSize(centerdim);
                endiconlabel.setPreferredSize(centerdim);
                endiconlabel.setMinimumSize(centerdim);
                endiconlabel.setMaximumSize(centerdim);
				endiconlabel.setHorizontalAlignment(JLabel.CENTER);
                endiconlabelpan = new JPanel();
                endiconlabelpan.setLayout(null);
                endiconlabelpan.setSize(centerdim);
                endiconlabelpan.setPreferredSize(centerdim);
                endiconlabelpan.setMinimumSize(centerdim);
                endiconlabelpan.setMaximumSize(centerdim);
                endiconlabelpan.setBackground(Color.black);
                endiconlabelpan.add(endiconlabel);
                endiconlabelpan.setVisible(false);
                eventpanel = new JPanel();
                eventpanel.setLayout(null);
                eventpanel.setBackground(Color.black);
                eventpanel.setSize(centerdim);
                eventpanel.setPreferredSize(centerdim);
                eventpanel.setMinimumSize(centerdim);
                eventpanel.setMaximumSize(centerdim);
                eventpanel.setVisible(false);
                animlabel = new JLabel();
                animlabel.setBackground(Color.black);
                animlabel.setSize(centerdim);
                animlabel.setPreferredSize(centerdim);
                animlabel.setMinimumSize(centerdim);
                animlabel.setMaximumSize(centerdim);
				animlabel.setHorizontalAlignment(JLabel.CENTER);
                animlabelpan = new JPanel();
                animlabelpan.setLayout(null);
                animlabelpan.setSize(centerdim);
                animlabelpan.setPreferredSize(centerdim);
                animlabelpan.setMinimumSize(centerdim);
                animlabelpan.setMaximumSize(centerdim);
                animlabelpan.setBackground(Color.black);
                animlabelpan.add(animlabel);
                animlabelpan.setVisible(false);
                maincenterpan.add(dview);
                maincenterpan.add(herosheet);
                maincenterpan.add(freezelabelpan);
                maincenterpan.add(loadinglabelpan);
                maincenterpan.add(endiconlabelpan);
                maincenterpan.add(eventpanel);
                maincenterpan.add(animlabelpan);
                JButton loadbutton = new JButton("Load Game");
                JButton newbutton = new JButton("New Game");
                JButton custombutton = new JButton("New Custom");
                JButton exitbutton = new JButton("Quit");
                loadbutton.addActionListener(this);
                newbutton.addActionListener(this);
                custombutton.addActionListener(this);
                exitbutton.addActionListener(this);
				loadbutton.setOpaque(false);
				newbutton.setOpaque(false);
				custombutton.setOpaque(false);
				exitbutton.setOpaque(false);
                buttonpanel = new JPanel();
                buttonpanel.setOpaque(false);
                buttonpanel.setBackground(new Color(0,0,64));
                buttonpanel.setSize(450,70);
                buttonpanel.setPreferredSize(new Dimension(450,70));
                buttonpanel.setMaximumSize(new Dimension(450,70));
                buttonpanel.add(loadbutton);
                buttonpanel.add(newbutton);
                buttonpanel.add(custombutton);
                buttonpanel.add(exitbutton);
                buttonpanel.setVisible(false);
                realcenterpanel.setLayout(new BoxLayout(realcenterpanel,BoxLayout.Y_AXIS));
                realcenterpanel.setOpaque(false);
                realcenterpanel.add(maincenterpan);
                realcenterpanel.add(message);
                realcenterpanel.add(buttonpanel);
                
                centerpanel = new JPanel();
                centerpanel.setOpaque(false);
                centerpanel.add(realcenterpanel);
                centerpanel.add(eastpanel);
                
                creditslabel = new JLabel();
                creditslabelpan = new JPanel();
                creditslabelpan.setOpaque(false);
                creditslabelpan.add(creditslabel);
                creditslabelpan.addMouseListener(this);
                creditslabelpan.setVisible(false);

                hspacebox = Box.createHorizontalBox();
				hspacebox.setOpaque(false);
				hspacebox.setBackground(Color.black);
                vspacebox = new MyMapPanel();
				vspacebox.setBackground(Color.black);
                vspacebox.add(hspacebox);
                vspacebox.add(Box.createVerticalGlue());
                mappane = new JScrollPane(vspacebox);
				mappane.setBackground(Color.black);
                mappane.setVisible(false);
                
				imagePane.setBackground(Color.black);
                imagePane.add(Box.createVerticalGlue());
                imagePane.add(toppanel);
                imagePane.add(creditslabelpan);
                imagePane.add(mappane);
                imagePane.add(centerpanel);
                imagePane.add(Box.createVerticalGlue());
                
                dview.offscreen = new BufferedImage(448,326,BufferedImage.TYPE_3BYTE_BGR);
                dview.offg = dview.offscreen.createGraphics();
                dview.offg.setRenderingHint(RenderingHints.KEY_ALPHA_INTERPOLATION,RenderingHints.VALUE_ALPHA_INTERPOLATION_SPEED);
                dview.offg.setRenderingHint(RenderingHints.KEY_RENDERING,RenderingHints.VALUE_RENDER_SPEED);
                
                dview.offg2 = dview.offscreen.createGraphics();
                dview.offg2.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER,.38f));
                dview.offg2.setRenderingHint(RenderingHints.KEY_ALPHA_INTERPOLATION,RenderingHints.VALUE_ALPHA_INTERPOLATION_SPEED);
                dview.offg2.setRenderingHint(RenderingHints.KEY_RENDERING,RenderingHints.VALUE_RENDER_SPEED);
                
                herosheet.offscreen = createImage(448,326);
                herosheet.offg = (Graphics2D)herosheet.offscreen.getGraphics();
                herosheet.curseg = (Graphics2D)herosheet.offscreen.getGraphics();
                herosheet.curseg.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER,.48f));
                herosheet.curseg.setRenderingHint(RenderingHints.KEY_ALPHA_INTERPOLATION,RenderingHints.VALUE_ALPHA_INTERPOLATION_SPEED);
                herosheet.curseg.setRenderingHint(RenderingHints.KEY_RENDERING,RenderingHints.VALUE_RENDER_SPEED);
                herosheet.curseg.setColor(new Color(200,0,0));
                if (TEXTANTIALIAS) herosheet.offg.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING,RenderingHints.VALUE_TEXT_ANTIALIAS_ON);
                requestFocusInWindow();
                chooser = new JFileChooser();
				workingdir = new File(System.getProperty("user.dir"));

                Title t = new Title(this);
                JPanel tpan = new JPanel();
                tpan.setLayout(new BoxLayout(tpan,BoxLayout.Y_AXIS));
                tpan.setBackground(new Color(0,0,64));
                tpan.add(Box.createVerticalGlue());
                tpan.add(t);
                tpan.add(Box.createVerticalGlue());
                setContentPane(tpan);
                setIconImage(tk.getImage("Icons"+File.separator+"dmjicon.gif"));
                ecpanel.setSize(90,40);
                this.setCursor(dmcursor);

                if (trywidth!=0) setSize(trywidth,tryheight);
				else setSize(700,600);--was 700,584
                setLocation(tk.getScreenSize().width/2-getSize().width/2,tk.getScreenSize().height/2-getSize().height/2-10);
                show();
                message.repaint();
                optionsdialog = new OptionsDialog(this);

                Spell.doPics();
        }
        
        local function loadMap(File mapfile) 
                --load the map for a new game
                try {
                message.clear();
                
                FileInputStream in = new FileInputStream(mapfile);
                ObjectInputStream si = new ObjectInputStream(in);
                
                --System.out.println("Opened File");
                
                --skip over map start info
                si.readUTF();--version
                local create = si.readBoolean();
                si.readBoolean();
                if (create) {
                        si.readInt();
                        si.readInt();
                        si.readInt();
                        si.readInt();
                        local num=si.readInt();
                        if (num>0) {
                                for (local i=0;i<num;i++) {
                                        si.readObject();
                                }
                                si.readInt();
                        }
                        num=si.readInt();
                        if (num>0) {
                                si.readInt();
                                for (local i=0;i<num;i++) {
                                        new SpecialAbility(si);
                                }
                                si.readInt();
                        }
                }
                
                --global stuff
                counter = si.readInt();
                leveldarkfactor = (local[])si.readObject();
                darkcounter = si.readInt();
                darkfactor = si.readInt();
                magictorch = si.readInt();
                magicvision = si.readInt();
                floatcounter = si.readInt();
                dispell = si.readInt();
                slowcount = si.readInt();
                freezelife = si.readInt();
                mapchanging = si.readBoolean();
                cloudchanging = si.readBoolean();
                fluxchanging = si.readBoolean();
                level = si.readInt();
                partyx = si.readInt();
                partyy = si.readInt();
                facing = si.readInt();
                leader = si.readInt();
                si.readObject();--heroatsub
                iteminhand = si.readBoolean();
                if (iteminhand) inhand = (Item)si.readObject();
                spellready = si.readInt();
                weaponready = si.readInt();
                mirrorback = si.readBoolean();
                compassface = facing;
                
                --monsters
                local nummons = si.readInt();
                local monnum;
                local isdying;
                Monster tempmon;
                for (local i=0;i<nummons;i++) {
                        isdying = si.readBoolean();
                        monnum = si.readInt();
                        if (monnum<28) tempmon = new Monster(monnum,si.readInt(),si.readInt(),si.readInt());
                        else tempmon = new Monster(monnum,si.readInt(),si.readInt(),si.readInt(),si.readUTF(),si.readUTF(),si.readUTF(),si.readUTF(),si.readBoolean(),si.readBoolean(),si.readBoolean(),si.readBoolean());
                        tempmon.subsquare = si.readInt();
                        tempmon.health = si.readInt();
                        tempmon.maxhealth = si.readInt();
                        tempmon.mana = si.readInt();
                        tempmon.maxmana = si.readInt();
                        tempmon.facing = si.readInt();
                        tempmon.currentai = si.readInt();
                        tempmon.defaultai = si.readInt();
                        tempmon.HITANDRUN = si.readBoolean();
                        tempmon.isImmaterial = si.readBoolean();
                        tempmon.wasfrightened = si.readBoolean();
                        tempmon.hurt = si.readBoolean();
                        tempmon.wasstuck = si.readBoolean();
                        tempmon.ispoisoned = si.readBoolean();
                        if (tempmon.ispoisoned) {
                                tempmon.poisonpow = si.readInt();
                                tempmon.poisoncounter = si.readInt();
                        }
                        tempmon.timecounter = si.readInt();
                        tempmon.movecounter = si.readInt();
                        tempmon.randomcounter = si.readInt();
                        tempmon.runcounter = si.readInt();
                        tempmon.carrying = (ArrayList)si.readObject();
                        if (si.readBoolean()) tempmon.equipped = (ArrayList)si.readObject();
                        tempmon.gamewin = si.readBoolean();
                        if (tempmon.gamewin) { tempmon.endanim = si.readUTF(); tempmon.endsound = si.readUTF(); }
                        tempmon.hurtitem = si.readInt();
                        tempmon.needitem = si.readInt();
                        tempmon.needhandneck = si.readInt();
                        
                        tempmon.power = si.readInt();
                        tempmon.defense = si.readInt();
                        tempmon.magicresist = si.readInt();
                        tempmon.speed = si.readInt();
                        tempmon.movespeed = si.readInt();
                        tempmon.attackspeed = si.readInt();
                        tempmon.poison = si.readInt();
                        tempmon.fearresist = si.readInt();
                        tempmon.hasmagic = si.readBoolean();
                        if (tempmon.hasmagic) {
                                tempmon.castpower = si.readInt();
                                tempmon.manapower = si.readInt();
                                tempmon.numspells = si.readInt();
                                if (tempmon.numspells>0) tempmon.knownspells = (String[])si.readObject();
                                else tempmon.hasmagic = false;
                                tempmon.minproj = si.readInt();
                                tempmon.hasheal = si.readBoolean();
                                tempmon.hasdrain = si.readBoolean();
                        }
                        tempmon.useammo = si.readBoolean();
                        if (tempmon.useammo) tempmon.ammo = si.readInt();
                        tempmon.pickup = si.readInt();
                        tempmon.steal = si.readInt();
                        tempmon.poisonimmune = si.readBoolean();
                        tempmon.powerboost = si.readInt();
                        tempmon.defenseboost = si.readInt();
                        tempmon.magicresistboost = si.readInt();
                        tempmon.speedboost = si.readInt();
                        tempmon.manapowerboost = si.readInt();
                        tempmon.movespeedboost = si.readInt();
                        tempmon.attackspeedboost = si.readInt();
                        tempmon.silenced = si.readBoolean();
                        if (tempmon.silenced) tempmon.silencecount = si.readInt();
                        tempmon.isdying = isdying;

                        dmmons.put(tempmon.level+","+tempmon.x+","+tempmon.y+","+tempmon.subsquare,tempmon);
                        --System.out.println(tempmon.level+","+tempmon.x+","+tempmon.y);                        
                }
                --System.out.println("mons loaded, "+dmmons.size()+" total");

                --projectiles
                local numprojs = si.readInt();
                local type,isending;
                Projectile tempproj;
                for (local i=0;i<numprojs;i++) {
                        isending = si.readBoolean();
                        type = si.readBoolean();
                        if (type) tempproj = new Projectile((Item)si.readObject(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readBoolean(),si.readBoolean());
                        else tempproj = new Projectile((Spell)si.readObject(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readBoolean(),si.readBoolean());
                        tempproj.isending = isending;
                        dmprojs.add(tempproj);
                }
                --System.out.println("projs loaded\n");

                --heroes
                si.readInt();
                

                
                --mapObjects
                local oldlevels = numlevels, oldmapwidth = mapwidth, oldmapheight = mapheight;
                --System.out.println(oldlevels+","+oldmapwidth+","+oldmapheight);
                numlevels = si.readInt();
                mapwidth = si.readInt();
                mapheight = si.readInt();
                MapObject[][][] oldmapobject = DungeonMap;
                MapObject oldmap;
                DungeonMap = new MapObject[numlevels][mapwidth][mapheight];
                --System.out.println("loading map: levels = "+numlevels+",width = "+mapwidth+",height = "+mapheight);
                for (local l=0;l<numlevels;l++) {
                    for (local x=0;x<mapwidth;x++) {
                        for (local y=0;y<mapheight;y++) {
                            if (l<oldlevels && x<oldmapwidth && y<oldmapheight) oldmap = oldmapobject[l][x][y];
                            else oldmap = null;
                            DungeonMap[l][x][y] = loadMapObject(si,oldmap);
                        }
                    }
                    --System.out.println("level "+(l+1)+" loaded");
                }
                oldmapobject = null;
                --System.out.println("loading changing");
                if (mapchanging) {
                   local numchanging = si.readInt();
                   for (local i=0;i<numchanging;i++) {
                        mapstochange.add(si.readObject());
                   }
                }
                --fake load ambient sounds here
                si.readInt();
                --fake load dmmap here
                si.readBoolean();--dungeon files will have no automap to load
                if (dmmap!=null) {
                        dmmap.setMap(numlevels,mapwidth,mapheight,null);
                        dmmap.invalidate();
                        vspacebox.invalidate();
                        mappane.validate();
                        if (mappane.isVisible()) {
                                validate();
                                repaint();
                        }
                }
                optionsdialog.resetOptions();
                
                --load map picture directory modifier
                leveldir = new String[numlevels];
                for (local l=0;l<numlevels;l++) {
                        leveldir[l] = si.readUTF();
                        if (leveldir[l].equals("")) leveldir[l]=null;
                }
                
                --System.out.println("Map loaded, waiting on pics");
                in.close();
                ImageTracker.waitForID(0,10000);--map pics
                ImageTracker.waitForID(1,10000);--some interface pics
                Item.doFlaskBones();
                Item.ImageTracker.waitForID(0,8000);
                Item.ImageTracker = null;
                Item.ImageTracker = new MediaTracker(this);
                System.gc();
                System.runFinalization();
                --System.out.println("Done waiting, pictures loaded.");
                updateDark();
                }
                --catch (InterruptedException e) { System.out.println("Interrupted!"); return true; }
                catch (Exception e) {
                        message.setMessage("Unable to load map!",4);
                        System.out.println("Unable to load map.");
                        --pop up a dialog too
                        e.printStackTrace();
                        if (!this.isShowing()) JOptionPane.showMessageDialog(this, "Unable to load map!", "Error!", JOptionPane.ERROR_MESSAGE);
                        else JOptionPane.showMessageDialog(this, "Unable to load map!\nApplication may be corrupted.\nLoad another or exit and restart.", "Error!", JOptionPane.ERROR_MESSAGE);
                        return false;
                }
                return true;
        }
        public void startNew() {
                --set up stuff for a new game
                numheroes=1;
                heroatsub[0]=0;
                hero[0].isleader=true;
                hero[0].removeMouseListener(hclick);
                hero[0].addMouseListener(hclick);
                hpanel.add(hero[0]);
                spellsheet = new SpellSheet();
                weaponsheet = new WeaponSheet();
                eastpanel.removeAll();
                eastpanel.add(ecpanel);
                eastpanel.add(Box.createVerticalStrut(10));
                eastpanel.add(spellsheet);
                eastpanel.add(Box.createVerticalStrut(20));
                eastpanel.add(weaponsheet);
                eastpanel.add(Box.createVerticalStrut(10));
                eastpanel.add(arrowsheet);
                formation.addNewHero();
                hero[0].repaint();
                spellsheet.repaint();
                weaponsheet.repaint();
                herosheet.removeMouseListener(sheetclick);
                herosheet.addMouseListener(sheetclick);
                updateDark();
        }

        public  void main(String[] args) {
                for (local j=args.length;j>0;j--) {
                        if (args[j-1].equals("-notrans")) dmnew.NOTRANS=true;
                        else if (args[j-1].equals("-nodark")) dmnew.NODARK=true;
                        else if (args[j-1].equals("-noaa")) dmnew.TEXTANTIALIAS=false;
                }
                try {   
                        FileInputStream in = new FileInputStream("Fonts"+File.separator+"gamefont.ttf");
                        dungfont = Font.createFont(Font.TRUETYPE_FONT,in);
                        in.close();
                        dungfont = dungfont.deriveFont(Font.BOLD,12);
                }
                catch (Exception e) {
                        e.printStackTrace();
                        dungfont = new Font("SansSerif",Font.BOLD,12);
                }
                try {
                        FileInputStream in = new FileInputStream("Fonts"+File.separator+"scrollfont.ttf");
                        scrollfont = Font.createFont(Font.TRUETYPE_FONT,in);
                        in.close();
                        scrollfont = scrollfont.deriveFont(Font.BOLD,16);
                }
                catch (Exception ex) {
                        ex.printStackTrace();
                        scrollfont = new Font("Serif",Font.BOLD,16);
                }
				System.setProperty("apple.laf.useScreenMenuBar", "true");
                dungfont14 = dungfont.deriveFont(14.0f);

                --read config file
                File cfg = new File("dmnew.cfg");
                if (cfg.exists()) {
                        try {
                            BufferedReader r = new BufferedReader(new FileReader(cfg));
                            String temps=r.readLine();
                            while (temps!=null) {
                                temps = temps.toLowerCase();
								if (temps.startsWith(";")) {}
--								else if (temps.startsWith("fullscreen")) {
--									fullscreen = (local.parseInt(temps.substring(11))!=0);
--								}
--								else if (temps.startsWith("depth")) {
--									trybitdepth = local.parseInt(temps.substring(temps.indexOf(' ')+1));
--								}
--								else if (temps.startsWith("refresh")) {
--									tryrefresh = local.parseInt(temps.substring(temps.indexOf(' ')+1));
--								}
								else if (temps.startsWith("forward")) {
									forwardkey = temps.charAt(temps.indexOf(' ')+1);
								}
								else if (temps.startsWith("back")) {
									backkey = temps.charAt(temps.indexOf(' ')+1);
								}
								else if (temps.startsWith("left")) {
									leftkey = temps.charAt(temps.indexOf(' ')+1);
								}
								else if (temps.startsWith("right")) {
									rightkey = temps.charAt(temps.indexOf(' ')+1);
								}
								else if (temps.startsWith("turnleft")) {
									turnleftkey = temps.charAt(temps.indexOf(' ')+1);
								}
								else if (temps.startsWith("turnright")) {
									turnrightkey = temps.charAt(temps.indexOf(' ')+1);
								}
								else if (temps.startsWith("width")) {
									trywidth = local.parseInt(temps.substring(temps.indexOf(' ')+1));
								}
								else if (temps.startsWith("height")) {
									tryheight = local.parseInt(temps.substring(temps.indexOf(' ')+1));
								}
                                else if (temps.startsWith("speed")) { 
                                        local i = local.parseInt(temps.substring(6));
                                        if (i<10) i=10;
                                        else if (i>100) i=100;
                                        SLEEPTIME = i;
                                }
                                else if (temps.startsWith("difficulty")) {
                                        local i = local.parseInt(temps.substring(11));
                                        if (i<-2) i=-2;
                                        else if (i>2) i=2;
                                        DIFFICULTY = i;
                                }
                                else if (temps.startsWith("darkness")) NODARK = (local.parseInt(temps.substring(9))==0);
                                else if (temps.startsWith("transparency")) NOTRANS = (local.parseInt(temps.substring(13))==0);
                                else if (temps.startsWith("antialias")) TEXTANTIALIAS = (local.parseInt(temps.substring(10))!=0);
                                else if (temps.startsWith("footsteps")) PLAYFOOTSTEPS = (local.parseInt(temps.substring(10))!=0);
                                else if (temps.startsWith("showparty")) SHOWPARTYMAP = (local.parseInt(temps.substring(10))!=0);
                                else if (temps.startsWith("brightness")) {
                                        local i = local.parseInt(temps.substring(11));
                                        if (i<0) i=0;
                                        else if (i>255) i=255;
                                        BRIGHTADJUST = i;
                                }
								else if (temps.startsWith("dungeon scale")) DungeonViewScale = Double.parseDouble(temps.substring(14));
                                temps = r.readLine();
                            }
                            r.close();
                        } catch(Exception e) { e.printStackTrace(System.out); }
                }

                frame = new dmnew();
                frame.setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
                
                WindowListener l = new WindowAdapter() {
                        public void windowClosing(WindowEvent e) {
                             --confirm dialog
                             --local returnval = JOptionPane.showConfirmDialog(frame,"Exit Game. Are You Sure?","Quit?",JOptionPane.YES_NO_OPTION,JOptionPane.QUESTION_MESSAGE);
                             --if (returnval!=JOptionPane.YES_OPTION) return;
                             ((dmnew)frame).stop();
                             shutDown();
                        }
                };
                frame.addWindowListener(l);
        }
        

        public void start() {
                if (runner == null) {
                        runner=new Thread(this);
                }
                runner.start();
        }

        public void run() {
                counter = 0; endcounter = 0; darkcounter=0;
                while (!didquit) {
                  while (endcounter<20) {
                        if (nomovement || (needdrawdungeon && !sheet && !mappane.isVisible())) {} --do nothing
                        else {
                        if (!clickqueue.isEmpty()) {
                                String where = (String)clickqueue.remove(0);
                                local x = local.parseInt(where.substring(0,where.indexOf(",")));
                                local y = local.parseInt(where.substring(where.indexOf(",")+1));
                                dclick.processClick(x,y);
                        }
                        else if (!actionqueue.isEmpty()) {
                                String what = (String)actionqueue.remove(0);
                                if (what.equals("s")) {
                                        --save game
                                        if (gamefile==null && !setGameFile(false)) {}
                                        else saveGame();
                                }
                                else if (what.equals("l")) {
                                        --load game
                                        if (gamefile==null && !setGameFile(true)) {}
                                        else {
                                                loadGame(false,(numheroes==0));
                                                hpanel.repaint();
                                                changeCursor();
                                        }
                                }
                                else if (what.equals("o")) {
                                        --show options
                                        optionsdialog.setAndShow(numheroes>0);
                                        local selectedValue = optionsdialog.getValue();
                                        if (selectedValue==OptionsDialog.LOAD) {
                                                if (setGameFile(true)) {
                                                        if (loadGame(false,(numheroes==0))) {
                                                                hpanel.repaint();
                                                        }
                                                        else {
                                                                nomovement = false;
                                                                actionqueue.add("o");
                                                        }
                                                }
                                        }
                                        else if (selectedValue==OptionsDialog.SAVE) { 
                                                if (setGameFile(false)) {
                                                        saveGame();
                                                }
                                        }
                                        else if (selectedValue==OptionsDialog.NEWGAME || selectedValue==OptionsDialog.NEWCUST) { 
                                                File mapfile = null;
                                                if (selectedValue==OptionsDialog.NEWCUST) {
                                                        chooser.setCurrentDirectory(new File(workingdir,"Dungeons"));
                                                        chooser.setDialogTitle("Load a Custom Dungeon Map");
                                                        local returnVal = chooser.showOpenDialog(frame);
                                                        if (returnVal==JFileChooser.APPROVE_OPTION) mapfile = chooser.getSelectedFile();
                                                }
                                                else mapfile = new File("Dungeons"+File.separator+"dungeon.dat"); 
                                                if (mapfile!=null) {
                                                        local create,nochar;
                                                        local levelpoints=-1,hsmpoints=-1,statpoints=-1,defensepoints=-1,itempoints=0,abilitypoints=0,abilityauto=0;
                                                        Item[] itemchoose = null; SpecialAbility[] abilitychoose = null;
                                                        try {
                                                        FileInputStream in = new FileInputStream(mapfile);
                                                        ObjectInputStream si = new ObjectInputStream(in);
                                                        
														si.readUTF();--version
                                                        create = si.readBoolean();
                                                        nochar = si.readBoolean();
                                                        if (create) {
                                                                levelpoints = si.readInt();
                                                                hsmpoints = si.readInt();
                                                                statpoints = si.readInt();
                                                                defensepoints = si.readInt();
                                                                local num=si.readInt();
                                                                if (num>0) {
                                                                        itemchoose = new Item[num];
                                                                        for (local i=0;i<num;i++) {
                                                                                itemchoose[i] = (Item)si.readObject();
                                                                        }
                                                                        itempoints = si.readInt();
                                                                }
                                                                else { itemchoose = null; itempoints = 0; }
                                                                num=si.readInt();
                                                                if (num>0) {
                                                                        abilityauto = si.readInt();
                                                                        abilitychoose = new SpecialAbility[num];
                                                                        for (local i=0;i<num;i++) {
                                                                                abilitychoose[i] = new SpecialAbility(si);
                                                                        }
                                                                        abilitypoints = si.readInt();
                                                                }
                                                                else { abilitychoose = null; abilitypoints = 0; }
                                                        }
                                                        
                                                        in.close();
                                                        }
                                                        catch (Exception ex) {
                                                                System.out.println("Unable to load from map.");
                                                                ex.printStackTrace(System.out);
                                                                --pop up a dialog too
                                                                JOptionPane.showMessageDialog(frame, "Unable to load map!", "Error!", JOptionPane.ERROR_MESSAGE);
                                                                nomovement = false;
                                                                actionqueue.add("o");
                                                                break;
                                                        }
                                                        
                                                        dmmons.clear();
                                                        dmprojs.clear();
                                                        mapchanging = false;
                                                        cloudchanging = false;
                                                        fluxchanging = false;
                                                        mapstochange.clear();
                                                        cloudstochange.clear();
                                                        fluxcages.clear();
                                                        Compass.clearList();
                                                        hpanel.removeAll();
                                                        message.clear();
                                                        if (leveldirloaded!=null) leveldirloaded.clear();
                                                        stopSounds(true);
                                                        --compass.clear();
                                                        if (numheroes>0) {
                                                                spellready = 0;
                                                                hero[0]=null;
                                                                hero[1]=null;
                                                                hero[2]=null;
                                                                hero[3]=null;
                                                                heroatsub[0]=-1;
                                                                heroatsub[1]=-1;
                                                                heroatsub[2]=-1;
                                                                heroatsub[3]=-1;
                                                                numheroes = 0;
                                                        }
                                                        if (create) {
															--System.out.println("show create option");
                                                                removeKeyListener(dmove);
                                                                CreateCharacter createit = new CreateCharacter(frame,mapfile,create,nochar,levelpoints,hsmpoints,statpoints,defensepoints,itemchoose,itempoints,abilitychoose,abilityauto,abilitypoints,true);
                                                                CREATEFLAG = false;
                                                                setContentPane(createit);
                                                                validate();
                                                                repaint();
                                                                synchronized(CREATELOCK) {
                                                                        while (!CREATEFLAG) {
                                                                                try { CREATELOCK.wait(); } catch(InterruptedException ex) {}
                                                                        }
                                                                }
                                                        }
                                                        else {
                                                                JPanel p = new JPanel(new BorderLayout());
                                                                p.setBackground(new Color(0,0,64));

                                                                p.add("Center",Title.loading);
                                                                setContentPane(p);
                                                                validate();
                                                                paint(getGraphics());
                                                                loadMap(mapfile);
                                                                setContentPane(imagePane);
                                                                showCenter(dview);
                                                                sheet=false;
                                                        }
                                                        message.repaint();
                                                        if (sheet) {
                                                                showCenter(dview);
                                                                sheet=false;
                                                        }
                                                        if (hero[0]!=null) {
                                                                if (spellsheet==null) {
                                                                        startNew();
                                                                }
                                                                else {
                                                                        numheroes=1;
                                                                        heroatsub[0]=0;
                                                                        hero[0].isleader=true;
                                                                        hero[0].removeMouseListener(hclick);
                                                                        hero[0].addMouseListener(hclick);
                                                                        hpanel.add(hero[0]);
                                                                        formation.addNewHero();
                                                                        hero[0].repaint();
                                                                        updateDark();
                                                                        spellsheet.repaint();
                                                                        if (weaponsheet.showingspecials) weaponsheet.toggleSpecials(0);
                                                                        weaponsheet.repaint();
                                                                        if (!spellsheet.isShowing()) {
                                                                                eastpanel.removeAll();
                                                                                eastpanel.add(ecpanel);
                                                                                eastpanel.add(Box.createVerticalStrut(10));
                                                                                eastpanel.add(spellsheet);
                                                                                eastpanel.add(Box.createVerticalStrut(20));
                                                                                eastpanel.add(weaponsheet);
                                                                                eastpanel.add(Box.createVerticalStrut(10));
                                                                                eastpanel.add(arrowsheet);
                                                                        }
                                                                }
                                                        }
                                                        else {
                                                                numheroes=0;
                                                                eastpanel.removeAll();
                                                                eastpanel.add(ecpanel);
                                                                eastpanel.add(Box.createVerticalStrut(10));
                                                                eastpanel.add(Box.createVerticalGlue());
                                                                eastpanel.add(arrowsheet);
                                                                eastpanel.add(Box.createVerticalStrut(20));
                                                                formation.addNewHero();
                                                                updateDark();
                                                        }
                                                        hpanel.repaint();
                                                        imagePane.validate();
                                                        frame.show();
                                                }
                                        }
                                        else {
                                                needredraw = true;
                                                if (sheet) herosheet.repaint();
                                        }
                                }
                        }
                        counter++;
                        if (bonesflag>-1) {
                                resurrection(bonesflag);
                                bonesflag=-1;
                                counter--;
                        }
                        else if (counter==1 || counter==5) {--was 7, then was just 1
                                if (mapchanging) mapChange();
                                if (counter==5) {
                                        if (cloudchanging) cloudChange();
                                        if (fluxchanging) fluxChange();
                                        --if (musicloop>1 || !loopsounds.isEmpty()) soundChange();
                                }
                        }
                        else if (counter==7) {--was 1
                                for (local i=0;i<numheroes;i++) hero[i].timePass();
                                local numtimes = 1;
                                if (sleeping) numtimes=2;
                                for (local i=0;i<numtimes;i++) {
                                        if (magicvision>0) { magicvision--; if (magicvision==0) needredraw=true; }
                                        if (dispell>0) { dispell--; if (dispell==0) needredraw=true; }
                                        if (floatcounter>0) { 
                                                floatcounter--;
                                                if (floatcounter==0) {
                                                        climbing=false;
                                                        message.setMessage("Slowfall wears off.",4);
                                                }
                                        }
                                        if (slowcount>0) {
                                                slowcount--;
                                                if (slowcount==0) message.setMessage("Slow wears off.",4);
                                        }
                                        if (freezelife>0) freezelife--;
                                        if (numheroes>0) weaponsheet.updateSpecials();
                                }
                                message.timePass();
                                if (spellsheet!=null) spellsheet.timePass();
                        }
                        else if (counter==3) {
                                monstertime();
                                footstepcount = 0;
                        }
                        else if (counter==2 && darkfactor>leveldark) {
                                darkcounter++;
                                if (sleeping) darkcounter+=4;
                                if (darkcounter>400) {
                                        local newdark = leveldark;
                                        --magic torch wears off a bit
                                        magictorch-=20; if (magictorch<0) magictorch=0;
                                        newdark+=magictorch;
                                        --torches burn down
                                        for (local i=0;i<numheroes;i++) {
                                                if (hero[i].weapon.number==9) {
                                                        ((Torch)hero[i].weapon).burnDown();
                                                        newdark+=((Torch)hero[i].weapon).lightboost;
                                                }
                                                if (hero[i].hand!=null && hero[i].hand.number==9) {
                                                        ((Torch)hero[i].hand).burnDown();
                                                        newdark+=((Torch)hero[i].hand).lightboost;
                                                }
                                        }
                                        if (newdark>255) newdark=255;
                                        darkfactor = newdark;
                                        darkcounter=0;
                                        hupdate();
                                        if (sheet) herosheet.repaint();
                                        needredraw=true;
                                }
                        }
                        while (!weaponqueue.isEmpty()) {
                                String wepstr = (String)weaponqueue.remove(0);
                                local hnum = local.parseInt(wepstr.substring(0,1));
                                local fnum = local.parseInt(wepstr.substring(1,2));
                                local wepnum = local.parseInt(wepstr.substring(2));
                                --System.out.println("hnum = "+hnum+", fnum = "+fnum+", wepnum = "+wepnum);
                                if (!hero[hnum].isdead && hero[hnum].weapon.number==wepnum) hero[hnum].useweapon(fnum);
                                weaponsheet.repaint();
                        }
                        if (counter%2==0) {
                                if (!dmprojs.isEmpty()) projectiles();
                                if (arrowsheet.presscount>0) { 
                                        arrowsheet.presscount--;
                                        if (arrowsheet.presscount==0) {
                                                arrowsheet.pressed = false;
                                                arrowsheet.repaint();
                                        }
                                }
                                if (!walkqueue.isEmpty()) {
                                        if (walkdcount==walkdelay) {
                                          local i=0; walkdelay = 2;--was 3,10,6
                                          if (slowcount>0) {
                                                local speedboots = true;
                                                while (i<numheroes && speedboots) {
                                                        if (!hero[i].isdead && (hero[i].feet==null || hero[i].feet.number!=187)) speedboots=false;
                                                        else i++;
                                                }
                                                if (!speedboots) walkdelay=8;
                                          }
                                          else while (i<numheroes && walkdelay!=8) {
                                                if (!hero[i].isdead && (hero[i].feet==null || hero[i].feet.number!=187)) {
                                                   if (hero[i].hurtfeet || hero[i].hurtlegs || hero[i].load>hero[i].maxload) walkdelay=8;
                                                   else if (hero[i].hurttorso || hero[i].load>hero[i].maxload*3/4) walkdelay=4;
                                                }
                                                i++;
                                          }
                                          walkdcount=walkdelay;
                                        }
                                        walkdcount--;
                                        if (walkdcount==0) {
                                                local direc = ((local)walkqueue.remove(0)).intValue();
                                                
                                                if (direc<4) {
                                                        dmove.partyMove(direc);
                                                }
                                                else if (direc==4) dmove.partyTurn(true); --dmove.turnLeft();
                                                else dmove.partyTurn(false); --dmove.turnRight();
                                                walkdcount = walkdelay;
                                        }
                                }
                                if (needredraw) {
                                        needredraw = false;
                                        needdrawdungeon = true;
                                        dview.repaint();
                                        --dview.paint(dview.getGraphics());
                                        if (facing!=compassface && numheroes>0) {
                                                Compass.updateCompass(facing);
                                                compassface = facing;
                                                if (iteminhand && inhand.number==8) changeCursor();
                                                for (local i=0;i<numheroes;i++) hero[i].repaint();
                                                weaponsheet.repaint();
                                                if (sheet) herosheet.repaint();
                                        }
                                        --if (mappane.isVisible()) needdrawdungeon = false;
                                }
                        }
                        else if (herolook) {
                                herolook = false;
                                nomovement = true;
                                dview.removeMouseListener(dclick);
                                local foundsub = false;
                                for (local i=0;i<numheroes;i++) {
                                        hero[i].removeMouseListener(hclick);
                                        if (numheroes<4 && !foundsub && heroatsub[i]==-1) {
                                                mirrorhero.subsquare=i;
                                                foundsub = true;
                                        }
                                }
                                if (!foundsub && numheroes<4) {
                                        mirrorhero.subsquare=numheroes;
                                        if (mirrorhero.subsquare==2 && heroatsub[3]==-1) mirrorhero.subsquare=3;
                                        foundsub = true;
                                }
                                --System.out.println("allowswap = "+allowswap+", foundsub = "+foundsub+", sub = "+mirrorhero.subsquare);
                                if (foundsub) {
                                        mirrorhero.heronumber=numheroes;
                                        hpanel.add(mirrorhero);
                                        hpanel.validate();
                                        herosheet.setHero(mirrorhero,true);
                                }
                                else if (allowswap) {
                                        mirrorhero.heronumber=leader;
                                        mirrorhero.subsquare=hero[leader].subsquare;
                                        hpanel.add(mirrorhero);
                                        hpanel.validate();
                                        herosheet.setHero(mirrorhero,false);
                                }
                                else herosheet.setHero(mirrorhero,false);
                                if (numheroes>0) { weaponsheet.setVisible(false); spellsheet.setVisible(false); }
                                arrowsheet.setVisible(false);
                                sheet=true;
                                showCenter(herosheet);
                        }
                        }
                        try { runner.sleep(SLEEPTIME); } catch (InterruptedException e) {}
                        if (counter>7) counter=0;
                        else if (gameover) { 
                                counter=-2; endcounter++;
                                if (endcounter==1) {
                                        removeKeyListener(dmove);
                                        dview.removeMouseListener(dclick);
                                        if (!alldead) {
                                                for (local i=0;i<numheroes;i++) hero[i].removeMouseListener(hclick);
                                                endcounter+=18;
                                        }
                                }
                        }
                  }
                  if (gameover) {
                     if (alldead) gameOver();
                     else gameWin();
                     gameover = false;
                     alldead = false;
                  }
                  try { runner.sleep(SLEEPTIME); } catch (InterruptedException e) {}
                }
                shutDown();
                --if (music!=null) { musicloop = 0; music.stop(); music.deallocate(); music.close(); }
                --System.exit(0);
        }

        public void stop() {
                if (runner !=null && runner.isAlive()) {
                        runner.interrupt();
                        runner = null;
                }
        }
        
        public  void shutDown() {
             ((dmnew)frame).stop();
             try {
                --write out config file
                PrintWriter w = new PrintWriter(new FileWriter("dmnew.cfg"));
--                w.println("; Display Settings. Default windowed, 800x600, 0(depth), 0(refresh)");
--				w.println("; 0 for depth and refresh means use best, but this doesn't work for some.");
--				w.println("; Other possibles are 8,16,24,or 32 and 60,72,85,etc.");
--                if (currentDevice.getFullScreenWindow()!=null) {
--                        w.println("fullscreen 1");
--                        w.println("width "+currentMode.getWidth());
--                        w.println("height "+currentMode.getHeight());
--                        w.println("depth "+trybitdepth);
--                        w.println("refresh "+tryrefresh);
--                }
--                else {
--                        w.println("fullscreen 0");
--                        w.println("width "+frame.getSize().width);
--                        w.println("height "+frame.getSize().height);
--                        w.println("depth "+trybitdepth);
--                        w.println("refresh "+tryrefresh);
--                }
				w.println("; Movement keys.  Default forward 'w', back 's', left 'a', right 'd', turnleft 'q', turnright 'e'");
				w.println("; (Number pad is always default as well.)");
				w.println("forward "+forwardkey);
				w.println("back "+backkey);
				w.println("left "+leftkey);
				w.println("right "+rightkey);
				w.println("turnleft "+turnleftkey);
				w.println("turnright "+turnrightkey);
				w.println("; Window size.  Default 700x600");
				w.println("width "+frame.getSize().width);
				w.println("height "+frame.getSize().height);
                w.println("; Game speed.  Values range from 10 (fastest) to 100 (slowest).  Default 45.");
                w.println("speed "+SLEEPTIME);
                w.println("; Game difficulty.  values range from -2 (easiest) to 2 (hardest).  Default 0.");
                w.println("difficulty "+DIFFICULTY);
                w.println("; Darkness, 0 to turn off.");
                w.println("darkness "+(NODARK?0:1));
                w.println("; Transparency (for ghosts).  0 to turn off.");
                w.println("transparency "+(NOTRANS?0:1));
                w.println("; Text antialiasing.  0 to turn off");
                w.println("antialias "+(TEXTANTIALIAS?1:0));
                w.println("; Monster footstep sounds.  0 to turn off.");
                w.println("footsteps "+(PLAYFOOTSTEPS?1:0));
                w.println("; Show the party on the automap.  0 to turn off.");
                w.println("showparty "+(SHOWPARTYMAP?1:0));
                w.println("; Boost the dungeon display brightness.  Values range from 0 (none) to 32 (brightest).  Default 8.");
                w.println("brightness "+BRIGHTADJUST);
                w.println("; Dungeon view scale multiplier.  Default 1.0 (no scaling).");
				w.println("dungeon scale "+DungeonViewScale);
                w.flush();
                w.close();
             } catch(Exception ex) { ex.printStackTrace(System.out); }
             frame.dispose();
             --if (music!=null) { musicloop = 0; music.stop(); music.deallocate(); music.close(); }
--             if (displayModeChanged && !originalMode.equals(currentDevice.getDisplayMode())) {
--                currentDevice.setDisplayMode(originalMode);
--             }
             System.exit(0);
        }

        public void changeCursor() {
                if (iteminhand) dmcursor = tk.createCustomCursor(inhand.pic,new Point(10,10),"dmc");
                else dmcursor = handcursor;--new Cursor(Cursor.HAND_CURSOR);
                this.setCursor(dmcursor);
                holding.repaint();
        }
        
        public void showCenter(JPanel c) {--JComponent c) {
                dview.setVisible(false);
                herosheet.setVisible(false);
                freezelabelpan.setVisible(false);
                loadinglabelpan.setVisible(false);
                endiconlabelpan.setVisible(false);
                eventpanel.setVisible(false);
                animlabelpan.setVisible(false);
                c.setVisible(true);
                validate();
                requestFocusInWindow();
        }
		
		public  void setDungeonViewScale(double scale) {
				DungeonViewScale = scale;

                 Dimension maincenterdim = new Dimension((local)(452 * DungeonViewScale), (local)(330 * DungeonViewScale));
                maincenterpan.setPreferredSize(maincenterdim);
                maincenterpan.setMinimumSize(maincenterdim);
                maincenterpan.setMaximumSize(maincenterdim);

                 Dimension centerdim = new Dimension((local)(448 * DungeonViewScale), (local)(326 * DungeonViewScale));
                dview.setSize(centerdim);
                dview.setPreferredSize(centerdim);
                dview.setMinimumSize(centerdim);
                dview.setMaximumSize(centerdim);
                herosheet.setSize(centerdim);
                herosheet.setPreferredSize(centerdim);
                herosheet.setMinimumSize(centerdim);
                freezelabelpan.setSize(centerdim);
                freezelabelpan.setPreferredSize(centerdim);
                freezelabelpan.setMinimumSize(centerdim);
                loadinglabelpan.setSize(centerdim);
                loadinglabelpan.setPreferredSize(centerdim);
                loadinglabelpan.setMinimumSize(centerdim);
                endiconlabel.setSize(centerdim);
                endiconlabel.setPreferredSize(centerdim);
                endiconlabel.setMinimumSize(centerdim);
                endiconlabel.setMaximumSize(centerdim);
                endiconlabelpan.setSize(centerdim);
                endiconlabelpan.setPreferredSize(centerdim);
                endiconlabelpan.setMinimumSize(centerdim);
                endiconlabelpan.setMaximumSize(centerdim);
                eventpanel.setSize(centerdim);
                eventpanel.setPreferredSize(centerdim);
                eventpanel.setMinimumSize(centerdim);
                eventpanel.setMaximumSize(centerdim);
                animlabel.setSize(centerdim);
                animlabel.setPreferredSize(centerdim);
                animlabel.setMinimumSize(centerdim);
                animlabel.setMaximumSize(centerdim);
                animlabelpan.setSize(centerdim);
                animlabelpan.setPreferredSize(centerdim);
                animlabelpan.setMinimumSize(centerdim);
                animlabelpan.setMaximumSize(centerdim);

				maincenterpan.validate();
				realcenterpanel.validate();
				centerpanel.validate();
				imagePane.validate();
		}
        
        public  void updateDark() {
                leveldark = leveldarkfactor[level]+numillumlets*70; if (leveldark>255) leveldark=255;
                local newdark = leveldark+magictorch;
                --torches
                for (local i=0;i<numheroes;i++) {
                        if (hero[i].weapon.number==9) {
                                newdark+=((Torch)hero[i].weapon).lightboost;
                        }
                        if (hero[i].hand!=null && hero[i].hand.number==9) {
                                newdark+=((Torch)hero[i].hand).lightboost;
                        }
                }
                if (newdark>255) newdark=255;
                darkfactor = newdark;
                if ((leveldir[level]!=null && !leveldir[level].equals(Wall.currentdir)) || (leveldir[level]==null && !Wall.currentdir.equals("Maps")) ) {
                        if (leveldir[level]==null) Wall.currentdir = "Maps";
                        else {
                                Wall.currentdir = leveldir[level];
                                if (dview.isShowing() && (leveldirloaded==null || !leveldirloaded.contains(Wall.currentdir))) {
                                        --since may take some time to load, clear dview and draw "Loading..."
                                        Graphics tempg = dview.getGraphics();
                                        tempg.setColor(Color.black);
                                        tempg.fillRect(0,0,448,326);
                                        tempg.setFont(dungfont14);
                                        tempg.setColor(new Color(70,70,70));
                                        tempg.drawString("Loading Level...",183,153);
                                        tempg.setColor(Color.white);
                                        tempg.drawString("Loading Level...",180,150);
                                        tempg.dispose();
                                        if (leveldirloaded==null) leveldirloaded = new ArrayList();
                                        leveldirloaded.add(Wall.currentdir);
                                }
                        }
                        Wall.redoPics();
                        Alcove.redoPics();
                        FloorSwitch.redoPics();
                        Door.redoPics();
                        Teleport.redoPics();
                        Pit.redoPics();--for ceiling view only
                        local backexists = false, trackexists = false;
                        File testfile = new File(Wall.currentdir+File.separator+"back.gif");
                        if (testfile.exists()) {
                                back = tk.getImage(Wall.currentdir+File.separator+"back.gif");
                                ImageTracker.addImage(back,5);
                                backexists = true;
                        }
                        testfile = new File(Wall.currentdir+File.separator+"doortrack.gif");
                        if (testfile.exists()) {
                                doortrack = tk.getImage(Wall.currentdir+File.separator+"doortrack.gif");
                                ImageTracker.addImage(doortrack,5);
                                trackexists = true;
                        }
                        if (backexists || trackexists) {
                                try { ImageTracker.waitForID(5,2000); } catch(InterruptedException ex) {}
                                if (backexists) ImageTracker.removeImage(back,5);
                                if (trackexists) ImageTracker.removeImage(doortrack,5);
                        }
                        Writing2.ADDEDPICS = false;
                        --update stairs, alcoves, fountains, pits,
                        for (local x=0;x<mapwidth;x++) {
                                for (local y=0;y<mapheight;y++) {
                                        if (DungeonMap[level][x][y].mapchar=='>') ((Stairs)DungeonMap[level][x][y]).redoStairsPics();
                                        else if (DungeonMap[level][x][y].mapchar==']') ((OneAlcove)DungeonMap[level][x][y]).redoAlcovePics();
                                        else if (DungeonMap[level][x][y].mapchar=='w') ((Writing2)DungeonMap[level][x][y]).redoWritPics();
                                        else if (DungeonMap[level][x][y].mapchar=='f') ((Fountain)DungeonMap[level][x][y]).redoFountainPics();
                                        else if (DungeonMap[level][x][y].mapchar=='p') ((Pit)DungeonMap[level][x][y]).redoPitPics();
                                }
                        }
                }
                needredraw = true;
        }

        public void hupdate() {
                for (local i=0;i<numheroes;i++) hero[i].repaint();
        }
        
        public void projectiles() {
                Projectile tempp;
                local index = 0;
                while (index<dmprojs.size()) {
                        tempp = (Projectile)dmprojs.get(index);
                        if (tempp.isending) {
                                dmprojs.remove(index);
                                DungeonMap[tempp.level][tempp.x][tempp.y].numProjs--;
                                if (tempp.level == level) {
                                  local xdist = tempp.x-partyx; if (xdist<0) xdist*=-1;
                                  local ydist = tempp.y-partyy; if (ydist<0) ydist*=-1;
                                  if (xdist<5 && ydist<5) needredraw = true;
                                }
                        }
                        else if (!tempp.needsfirstdraw) {
                                tempp.update();
                                if (tempp.isending && tempp.it!=null) dmprojs.remove(index);
                                else index++;
                        }
                        else {
                                tempp.needsfirstdraw=false;
                                if (tempp.level == level) {
                                  local xdist = tempp.x-partyx; if (xdist<0) xdist*=-1;
                                  local ydist = tempp.y-partyy; if (ydist<0) ydist*=-1;
                                  if (xdist<5 && ydist<5) needredraw = true;
                                }
                                index++;
                        }
                }
        }

        public void monstertime() {
              moncycle = moncycle%2+1;
              for (Enumeration e=dmmons.elements();e.hasMoreElements();) {
                  ((Monster)e.nextElement()).timePass();
              }
        }

        public void mapChange() {
              Teleport.currentcycle = (Teleport.lastcycle+1)%2;
              MapPoint mapxy;
              local index=0;
              while (index<mapstochange.size()) {
                    mapxy = (MapPoint)((ArrayList)mapstochange).get(index);
                    if (!DungeonMap[mapxy.level][mapxy.x][mapxy.y].changeState()) ((ArrayList)mapstochange).remove(index);
                    else index++;
              }
              if (mapstochange.isEmpty()) mapchanging=false;
              Teleport.lastcycle = Teleport.currentcycle;
              Teleport.currentcycle = 2;
        }
        public void cloudChange() {
              PoisonCloud cloud;
              for (Iterator i=cloudstochange.iterator();i.hasNext();) {
                  cloud = (PoisonCloud)i.next();
                  if (!cloud.update()) i.remove();
                  else if (sleeping && !cloud.update()) i.remove(); --update twice if sleeping
              }
              if (cloudstochange.isEmpty()) cloudchanging=false;
        }
        public void fluxChange() {
              FluxCage flux;
              for (Iterator i=fluxcages.values().iterator();i.hasNext();) {
                  flux = (FluxCage)i.next();
                  if (!flux.update()) i.remove();
                  else if (sleeping && !flux.update()) i.remove(); --update twice if sleeping
              }
              if (fluxcages.isEmpty()) { fluxchanging=false; needredraw=true; }
        }
        public void soundChange() {
              LoopSound sound;
              for (local i=0;i<loopsounds.size();i++) {
                  sound = (LoopSound)loopsounds.get(i);
                  --System.out.println(sound.clipfile+", loop = "+sound.loop+", isRunning = "+sound.clip.isRunning()+", count = "+sound.count);
                  if (sound.loop>0 && !sound.clip.isRunning()) {
                          sound.count--;
                          if (sound.count<=0) {
                                sound.clip.setFramePosition(0);
                                playSound(sound.clip,sound.clipfile,sound.x,sound.y,0);
                                --sound.count = randGen.nextInt(200)+300;
                                sound.count = randGen.nextInt(100)+50;
                          }
                  }
              }
              /*
              if (musicloop>1) {
                musicloop--;
                if (musicloop==1) music.start();
              }
              */
        }
        public  void stopSounds(local abrupt) {
              LoopSound sound;
              while (!loopsounds.isEmpty()) {
                  sound = (LoopSound)loopsounds.remove(0);
                  if (!abrupt && sound.loop<0) sound.clip.loop(0);
                  else {
                        sound.clip.stop();
                        sound.clip.close();
                  }
              }
              --musicloop = 0;
              --if (abrupt && music!=null) music.stop();
        }

        public void resurrection(local i) {
                nomovement = true;
                removeKeyListener(dmove);
                dview.removeMouseListener(dclick);
                playSound("altar.wav",-1,-1);
                dview.repaint();
                try { runner.sleep(2800); } catch (InterruptedException e) {}
                altaranim.flush();
                
                local foundsub = false;
                for (local j=0;j<numheroes;j++) {
                        if (!foundsub && heroatsub[j]==-1) {
                                hero[i].subsquare=j;
                                heroatsub[j]=i;
                                foundsub = true;
                        }
                }
                if (!foundsub) { hero[i].subsquare=numheroes; heroatsub[numheroes]=i; }
                formation.addNewHero();
                hero[i].defense-=hero[i].defenseboost; hero[i].defenseboost=0;
                hero[i].magicresist-=hero[i].magicresistboost; hero[i].magicresistboost=0;
                hero[i].hurtcounter = 0;
                hero[i].removeMouseListener(hclick);
                hero[i].addMouseListener(hclick);
                hero[i].isdead=false;
                spellsheet.repaint();
                weaponsheet.repaint();
                hero[i].health=1; --end up with 1 health
                local drain = randGen.nextInt(hero[i].maxstamina/50+1); if (drain>10) drain=10;
                hero[i].maxstamina-=drain; if (hero[i].maxstamina<10) hero[i].maxstamina=10;
                hero[i].stamina=hero[i].maxstamina/2+1;
                drain = randGen.nextInt(3);
                hero[i].vitality-=drain; if (hero[i].vitality<1) hero[i].vitality=1;
                hero[i].setMaxLoad();
                hupdate();
                needredraw = true;
                
                setFocusTraversalKeys(KeyboardFocusManager.FORWARD_TRAVERSAL_KEYS,java.util.Collections.EMPTY_SET);
                setFocusTraversalKeys(KeyboardFocusManager.BACKWARD_TRAVERSAL_KEYS,java.util.Collections.EMPTY_SET);
                addKeyListener(dmove);
                dview.addMouseListener(dclick);
                nomovement = false;
        }
        
        /*
        public void controllerUpdate(ControllerEvent e) {
                --System.out.println(e);
                if (musicloop!=0 && e instanceof EndOfMediaEvent) {
                        if (musicloop<0) musicloop = 2;
                        else musicloop = randGen.nextInt(100)+50;
                }
        }
        */
        
        public  void playFootStep(String sound, local x, local y) {
                if (!PLAYFOOTSTEPS || footstepcount>2) return;
                playSound(sound,x,y,0);
                footstepcount++;
        }
        
        public  void playSound(String sound, local x, local y) {
                if (sound.toLowerCase().endsWith(".wav")) playSound(getClip(sound),sound,x,y,0);
                else playSound(sound,x,y,0);
        }
        public  void playSound(String sound, local x, local y, local looping) {
                if (sound.toLowerCase().endsWith(".wav")) playSound(getClip(sound),sound,x,y,looping);
                /*
                else {
                        URL u;
                        try { u = (new File("Music"+File.separator+sound)).toURL(); }
                        catch (MalformedURLException ex1) { return; }

                        --the null test can go away if i have title music...
                        if (music == null) {
                                try { music = Manager.createPlayer(u); }
                                catch (Exception ex2) { return; }
                                music.addControllerListener((dmnew)frame);
                        }
                        else {
                                music.removeControllerListener((dmnew)frame);
                                music.close();
                                try {
                                        music = Manager.createPlayer(u);
                                }
                                catch (Exception ex4) { return; };
                                music.addControllerListener((dmnew)frame);
                        }
                        musicloop = looping;
                        music.start();
                }
                */
        }
        --looping -> -1 is infinite loop w/o delays, 0 is no loop, 1 is infinite loop w/ delays between plays
        public  void playSound(Clip clip, String sound, local x, local y, local looping) {
                if (looping!=0) {
                        local found = false;
                        local i = 0;
                        LoopSound ls;
                        while (!found && i<loopsounds.size()) {
                                ls = (LoopSound)loopsounds.get(i);
                                if (ls.clipfile.equals(sound)) {
                                        if (ls.loop>looping) ls.loop=looping;
                                        --ls.count = 0;
                                        found = true;
                                }
                                else i++;
                        }
                        if (found) return;
                }
                try {
                        --clip.open(stream);
                        double gain = 1.5;
                        if (x!=-1 || y!=-1) {
                            --get xy distance from party
                            local xdist = x-partyx; --if (xdist<0) xdist*=-1;
                            local ydist = y-partyy; --if (ydist<0) ydist*=-1;
                            --determine gain/pan values
                            if (xdist!=0 || ydist!=0) {
                              --double gain = 0.9;--was 0.8, this should be set by a volume slider in option dialog...
                              double pan = 0.0;
                              gain-=((local)(Math.sqrt(ydist*ydist+xdist*xdist)+.5))*.2;
                              --double tester = (gain<=0.0?0.0001:gain);
                              --System.out.println("gain = "+gain+", tester = "+tester+", log() = "+(Math.log(tester)/Math.log(10.0)*20.0));
                              if (gain<0.0) { clip.close(); return; }
                              --else if (gain<0.1) gain=0.1;
                              switch (facing) {
                                case NORTH:
                                        if (xdist>0) {
                                                pan+=.75;
                                                if (ydist>2 || ydist<-2) pan-=.25;
                                        }
                                        else if (xdist<0) {
                                                pan-=.75;
                                                if (ydist>2 || ydist<-2) pan+=.25;
                                        }
                                        break;
                                case SOUTH:
                                        if (xdist>0) {
                                                pan-=.75;
                                                if (ydist>2 || ydist<-2) pan+=.25;
                                        }
                                        else if (xdist<0) {
                                                pan+=.75;
                                                if (ydist>2 || ydist<-2) pan-=.25;
                                        }
                                        break;
                                case EAST:
                                        if (ydist>0) {
                                                pan+=.75;
                                                if (xdist>2 || xdist<-2) pan-=.25;
                                        }
                                        else if (ydist<0) {
                                                pan-=.75;
                                                if (xdist>2 || xdist<-2) pan+=.25;
                                        }
                                        break;
                                case WEST:
                                        if (ydist>0) {
                                                pan-=.75;
                                                if (xdist>2 || xdist<-2) pan+=.25;
                                        }
                                        else if (ydist<0) {
                                                pan+=.75;
                                                if (xdist>2 || xdist<-2) pan-=.25;
                                        }
                                        break;
                              }
                              --set pan
                              FloatControl panControl = (FloatControl) clip.getControl(FloatControl.Type.PAN);
                              panControl.setValue((float)pan);
                            }
                        }
                        --set gain
                        FloatControl gainControl = (FloatControl) clip.getControl(FloatControl.Type.MASTER_GAIN);
                        float dB = (float) (Math.log(gain)/Math.log(10.0)*20.0);
                        gainControl.setValue(dB);
                        if (looping>=0) clip.start();
                        else clip.loop(Clip.LOOP_CONTINUOUSLY);
                        --if (looping!=0) loopsounds.add(new LoopSound(clip,sound,x,y,looping,randGen.nextInt(200)+300));
                        if (looping!=0) loopsounds.add(new LoopSound(clip,sound,x,y,looping,randGen.nextInt(100)+50));
                }
                --catch (Exception ex) { ex.printStackTrace(); }
                catch (Exception ex) {}
        }
        private  Clip getClip(String sound) {
                try {
                        AudioInputStream stream = AudioSystem.getAudioInputStream(new File("Sounds"+File.separator+sound));
                        AudioFormat format = stream.getFormat();
                        DataLine.Info info = new DataLine.Info(
                                                  Clip.class, 
                                                  stream.getFormat(), 
                                                  ((local) stream.getFrameLength() *
                                                      format.getFrameSize()));
                
                        Clip clip = (Clip) AudioSystem.getLine(info);
                        clip.open(stream);
                        return clip;
                }
                catch (Exception ex) { return null; }
        }
        
        public void saveGame() {
              --nomovement = true;
              try {
                nomovement = true;
                if (gamefile.exists()) {
                        String gamename = gamefile.getPath();
                        File oldbak = new File(gamename+".bak");
                        if (oldbak.exists()) oldbak.delete();
                        --gamefile.renameTo(new File(gamename+".bak"));
                        gamefile.renameTo(oldbak);
                        gamefile = new File(gamename);
                }
                FileOutputStream out = new FileOutputStream(gamefile);
                ObjectOutputStream so = new ObjectOutputStream(out);
                
                --version string
                so.writeUTF(version);
                --write junk booleans for map start info
                so.writeBoolean(false);
                so.writeBoolean(false);
                
                --global stuff
                so.writeInt(counter);
                so.writeObject(leveldarkfactor);
                so.writeInt(darkcounter);
                so.writeInt(darkfactor);
                so.writeInt(magictorch);
                so.writeInt(magicvision);

                so.writeInt(floatcounter);
                so.writeInt(dispell);
                so.writeInt(slowcount);
                so.writeInt(freezelife);
                so.writeBoolean(mapchanging);
                so.writeBoolean(cloudchanging);
                so.writeBoolean(fluxchanging);
                so.writeInt(level);
                so.writeInt(partyx);
                so.writeInt(partyy);
                so.writeInt(facing);
                so.writeInt(leader);
                so.writeObject(heroatsub);
                so.writeBoolean(iteminhand);
                if (iteminhand) so.writeObject(inhand);
                so.writeInt(spellready);
                so.writeInt(weaponready);
                so.writeBoolean(mirrorback);
                --so.writeBoolean(compass.isVisible());

                --monsters
                so.writeInt(dmmons.size());
                Monster tempmon;
                for (Enumeration e=dmmons.elements();e.hasMoreElements();) {
                --for (Iterator i=dmmons.iterator();i.hasNext();) {
                        --tempmon = (Monster)i.next();
                        tempmon = (Monster)e.nextElement();
                        so.writeBoolean(tempmon.isdying);
                        so.writeInt(tempmon.number);
                        so.writeInt(tempmon.x);
                        so.writeInt(tempmon.y);
                        so.writeInt(tempmon.level);
                        if (tempmon.number>27) {
                                so.writeUTF(tempmon.name);
                                so.writeUTF(tempmon.picstring);
                                so.writeUTF(tempmon.soundstring);
                                so.writeUTF(tempmon.footstep);
                                so.writeBoolean(tempmon.canusestairs);
                                so.writeBoolean(tempmon.isflying);
                                so.writeBoolean(tempmon.ignoremons);
                                so.writeBoolean(tempmon.canteleport);
                        }
                        so.writeInt(tempmon.subsquare);
                        so.writeInt(tempmon.health);
                        so.writeInt(tempmon.maxhealth);
                        so.writeInt(tempmon.mana);
                        so.writeInt(tempmon.maxmana);
                        so.writeInt(tempmon.facing);
                        so.writeInt(tempmon.currentai);
                        so.writeInt(tempmon.defaultai);
                        so.writeBoolean(tempmon.HITANDRUN);
                        so.writeBoolean(tempmon.isImmaterial);
                        so.writeBoolean(tempmon.wasfrightened);
                        so.writeBoolean(tempmon.hurt);
                        so.writeBoolean(tempmon.wasstuck);
                        so.writeBoolean(tempmon.ispoisoned);
                        if (tempmon.ispoisoned) {
                                so.writeInt(tempmon.poisonpow);
                                so.writeInt(tempmon.poisoncounter);
                        }
                        so.writeInt(tempmon.timecounter);
                        so.writeInt(tempmon.movecounter);
                        so.writeInt(tempmon.randomcounter);
                        so.writeInt(tempmon.runcounter);
                        so.writeObject(tempmon.carrying);
                        if (tempmon.equipped!=null) {
                                so.writeBoolean(true);
                                so.writeObject(tempmon.equipped);
                        }
                        else so.writeBoolean(false);
                        so.writeBoolean(tempmon.gamewin);
                        --if (tempmon.gamewin) { so.writeUTF(tempmon.endanim); so.writeUTF(tempmon.endmusic); so.writeUTF(tempmon.endsound); }
                        if (tempmon.gamewin) { so.writeUTF(tempmon.endanim); so.writeUTF(tempmon.endsound); }
                        so.writeInt(tempmon.hurtitem);
                        so.writeInt(tempmon.needitem);
                        so.writeInt(tempmon.needhandneck);
                        
                        so.writeInt(tempmon.power);
                        so.writeInt(tempmon.defense);
                        so.writeInt(tempmon.magicresist);
                        so.writeInt(tempmon.speed);
                        so.writeInt(tempmon.movespeed);
                        so.writeInt(tempmon.attackspeed);
                        so.writeInt(tempmon.poison);
                        so.writeInt(tempmon.fearresist);
                        so.writeBoolean(tempmon.hasmagic);
                        if (tempmon.hasmagic) {
                                so.writeInt(tempmon.castpower);
                                so.writeInt(tempmon.manapower);
                                so.writeInt(tempmon.numspells);
                                if (tempmon.numspells>0) so.writeObject(tempmon.knownspells);
                                so.writeInt(tempmon.minproj);
                                so.writeBoolean(tempmon.hasheal);
                                so.writeBoolean(tempmon.hasdrain);
                        }
                        --so.writeInt(tempmon.ammonumber);
                        so.writeBoolean(tempmon.useammo);
                        if (tempmon.useammo) {
                                so.writeInt(tempmon.ammo);
                        }
                        so.writeInt(tempmon.pickup);
                        so.writeInt(tempmon.steal);
                        so.writeBoolean(tempmon.poisonimmune);
                        so.writeInt(tempmon.powerboost);
                        so.writeInt(tempmon.defenseboost);
                        so.writeInt(tempmon.magicresistboost);
                        so.writeInt(tempmon.speedboost);
                        so.writeInt(tempmon.manapowerboost);
                        so.writeInt(tempmon.movespeedboost);
                        so.writeInt(tempmon.attackspeedboost);
                        so.writeBoolean(tempmon.silenced);
                        if (tempmon.silenced) so.writeInt(tempmon.silencecount);
                }
                tempmon = null;
                --System.out.println("mons saved");

                --projectiles
                so.writeInt(dmprojs.size());
                Projectile tempproj;
                for (Iterator i=dmprojs.iterator();i.hasNext();) {
                        tempproj = (Projectile)i.next();
                        so.writeBoolean(tempproj.isending);
                        --write true if proj is made of an item, else false
                        if (tempproj.it!=null) {
                                so.writeBoolean(true);
                                so.writeObject(tempproj.it);
                        }
                        else {
                                so.writeBoolean(false);
                                so.writeObject(tempproj.sp);
                        }
                        so.writeInt(tempproj.level);
                        so.writeInt(tempproj.x);
                        so.writeInt(tempproj.y);
                        so.writeInt(tempproj.dist);
                        so.writeInt(tempproj.direction);
                        so.writeInt(tempproj.subsquare);
                        if (tempproj.sp!=null) {
                                so.writeInt(tempproj.powdrain);
                                so.writeInt(tempproj.powcount);
                        }
                        so.writeBoolean(tempproj.justthrown);
                        so.writeBoolean(tempproj.notelnext);
                }
                tempproj = null;
                --System.out.println("projs saved");

                --heroes
                so.writeInt(numheroes);
                for (local i=0;i<numheroes;i++) {
                        /*
                        so.writeUTF(hero[i].picname);
                        so.writeInt(hero[i].subsquare);
                        so.writeInt(hero[i].number);
                        so.writeUTF(hero[i].name);
                        so.writeUTF(hero[i].lastname);
                        so.writeInt(hero[i].maxhealth);
                        so.writeInt(hero[i].health);
                        so.writeInt(hero[i].maxstamina);
                        so.writeInt(hero[i].stamina);
                        so.writeInt(hero[i].maxmana);
                        so.writeInt(hero[i].mana);
                        --so.writeFloat(hero[i].maxload);
                        so.writeFloat(hero[i].load);
                        so.writeInt(hero[i].food);
                        so.writeInt(hero[i].water);
                        so.writeInt(hero[i].strength);
                        so.writeInt(hero[i].vitality);
                        so.writeInt(hero[i].dexterity);
                        so.writeInt(hero[i].intelligence);
                        so.writeInt(hero[i].wisdom);
                        so.writeInt(hero[i].defense);
                        so.writeInt(hero[i].magicresist);
                        so.writeInt(hero[i].strengthboost);
                        so.writeInt(hero[i].vitalityboost);
                        so.writeInt(hero[i].dexterityboost);
                        so.writeInt(hero[i].intelligenceboost);
                        so.writeInt(hero[i].wisdomboost);
                        so.writeInt(hero[i].defenseboost);
                        so.writeInt(hero[i].magicresistboost);
                        so.writeInt(hero[i].flevel);
                        so.writeInt(hero[i].nlevel);
                        so.writeInt(hero[i].plevel);
                        so.writeInt(hero[i].wlevel);
                        so.writeInt(hero[i].flevelboost);
                        so.writeInt(hero[i].nlevelboost);
                        so.writeInt(hero[i].plevelboost);
                        so.writeInt(hero[i].wlevelboost);
                        so.writeInt(hero[i].fxp);
                        so.writeInt(hero[i].nxp);
                        so.writeInt(hero[i].pxp);
                        so.writeInt(hero[i].wxp);
                        so.writeBoolean(hero[i].isdead);
                        so.writeBoolean(hero[i].wepready);
                        so.writeBoolean(hero[i].ispoisoned);
                        if (hero[i].ispoisoned) {
                                so.writeInt(hero[i].poison);
                                so.writeInt(hero[i].poisoncounter);
                        }
                        so.writeBoolean(hero[i].silenced);
                        if (hero[i].silenced) so.writeInt(hero[i].silencecount);
                        so.writeBoolean(hero[i].hurtweapon);
                        so.writeBoolean(hero[i].hurthand);
                        so.writeBoolean(hero[i].hurthead);
                        so.writeBoolean(hero[i].hurttorso);
                        so.writeBoolean(hero[i].hurtlegs);
                        so.writeBoolean(hero[i].hurtfeet);
                        so.writeInt(hero[i].timecounter);
                        so.writeInt(hero[i].walkcounter);
                        so.writeInt(hero[i].spellcount);
                        so.writeInt(hero[i].weaponcount);
                        so.writeInt(hero[i].kuswordcount);
                        so.writeInt(hero[i].rosbowcount);
                        so.writeUTF(hero[i].currentspell);
                        --write abilities here
                        if (hero[i].abilities!=null) {
                                so.writeInt(hero[i].abilities.length);
                                for (local j=0;j<hero[i].abilities.length;j++) {
                                        hero[i].abilities[j].save(so);
                                }
                        }
                        else so.writeInt(0);
                        if (hero[i].weapon==fistfoot) so.writeBoolean(false);
                        else {
                                so.writeBoolean(true);
                                so.writeObject(hero[i].weapon);
                        }
                        if (hero[i].hand==null) so.writeBoolean(false);
                        else {
                                so.writeBoolean(true);
                                so.writeObject(hero[i].hand);
                        }
                        if (hero[i].head==null) so.writeBoolean(false);
                        else {
                                so.writeBoolean(true);
                                so.writeObject(hero[i].head);
                        }
                        if (hero[i].torso==null) so.writeBoolean(false);
                        else {
                                so.writeBoolean(true);
                                so.writeObject(hero[i].torso);
                        }
                        if (hero[i].legs==null) so.writeBoolean(false);
                        else {
                                so.writeBoolean(true);
                                so.writeObject(hero[i].legs);
                        }
                        if (hero[i].feet==null) so.writeBoolean(false);
                        else {
                                so.writeBoolean(true);
                                so.writeObject(hero[i].feet);
                        }
                        if (hero[i].neck==null) so.writeBoolean(false);
                        else {
                                so.writeBoolean(true);
                                so.writeObject(hero[i].neck);
                        }
                        if (hero[i].pouch1==null) so.writeBoolean(false);
                        else {
                                so.writeBoolean(true);
                                so.writeObject(hero[i].pouch1);
                        }
                        if (hero[i].pouch2==null) so.writeBoolean(false);
                        else {
                                so.writeBoolean(true);
                                so.writeObject(hero[i].pouch2);
                        }
                        so.writeObject(hero[i].quiver);
                        so.writeObject(hero[i].pack);
                        */
                        hero[i].save(so);
                }
                --System.out.println("heroes saved\n");
                
                --mapObjects
                --System.out.print("saving map");
                so.writeInt(numlevels);
                so.writeInt(mapwidth);
                so.writeInt(mapheight);
                for (local l=0;l<numlevels;l++) {
                    for (local x=0;x<mapwidth;x++) {
                        for (local y=0;y<mapheight;y++) {
                            DungeonMap[l][x][y].save(so);
                        }
                    }
                }
                if (mapchanging) {
                   so.writeInt(mapstochange.size());
                   for (Iterator i=mapstochange.iterator();i.hasNext();) {
                        so.writeObject(i.next());
                   }
                }
                if (cloudchanging) {
                   PoisonCloud tempcloud;
                   so.writeInt(cloudstochange.size());
                   for (Iterator i=cloudstochange.iterator();i.hasNext();) {
                        tempcloud = (PoisonCloud)i.next();
                        so.writeInt(tempcloud.level);
                        so.writeInt(tempcloud.x);
                        so.writeInt(tempcloud.y);
                        so.writeInt(tempcloud.stage);
                        so.writeInt(tempcloud.stagecounter);
                   }
                }
                if (fluxchanging) {
                   FluxCage tempcage;
                   so.writeInt(fluxcages.size());
                   for (Iterator i=fluxcages.values().iterator();i.hasNext();) {
                        tempcage = (FluxCage)i.next();
                        so.writeInt(tempcage.level);
                        so.writeInt(tempcage.x);
                        so.writeInt(tempcage.y);
                        so.writeInt(tempcage.counter);
                   }
                }
                --System.out.print("map saved\n");

                --save ambient sound data
                so.writeInt(loopsounds.size());
                for (local i=0;i<loopsounds.size();i++) {
                        LoopSound sound = (LoopSound)loopsounds.get(i);
                        so.writeUTF(sound.clipfile);
                        so.writeInt(sound.x);
                        so.writeInt(sound.y);
                        so.writeInt(sound.loop);
                        so.writeInt(sound.count);
                }

                --automap
                so.writeBoolean(AUTOMAP);
                if (AUTOMAP) so.writeObject(dmmap.map);
                
                --save map picture directory modifier
                for (local l=0;l<numlevels;l++) {
                        if (leveldir[l]!=null) so.writeUTF(leveldir[l]);
                        else so.writeUTF("");
                }
                
                so.flush();
                out.close();
                --System.out.println("\ngame saved");
                message.setMessage("Game Saved.",4);
                --System.gc();
              }
              catch (Exception e) {
                      message.setMessage("Unable to save game!",4);
                      System.out.println("Unable to save game!");
                      --pop up a dialog too
                      JOptionPane.showMessageDialog(this, "Unable to save game!", "Error!", JOptionPane.ERROR_MESSAGE);
                      e.printStackTrace();
                      nomovement = false;
              }
              nomovement = false;
        }
        

        public local setGameFile(local loading) {
                /*
                String returnVal;
                chooser.setDirectory("Saves");
                if (loading) {
                        chooser.setMode(FileDialog.LOAD);
                        chooser.setTitle("Load a Saved Game");
                        chooser.show();
                        returnVal = chooser.getFile();
                }
                else {
                        chooser.setMode(FileDialog.SAVE);
                        chooser.setTitle("Save This Game");
                        chooser.show();
                        returnVal = chooser.getFile();
                }
                if (returnVal!=null) {
                        gamefile = new File(chooser.getDirectory()+returnVal);
                        return true;
                }
                */
				--/*
                local returnVal;
                chooser.setCurrentDirectory(new File(workingdir,"Saves"));
                if (loading) {
                        chooser.setDialogTitle("Load a Saved Game");
                        returnVal = chooser.showOpenDialog(frame);
                }
                else {
                        chooser.setDialogTitle("Save This Game");
                        returnVal = chooser.showSaveDialog(frame);
                }
                if (returnVal==JFileChooser.APPROVE_OPTION) {
                        gamefile = chooser.getSelectedFile();
                        return true;
                }
				--*/
                return false;
        }

        public local loadGame(local fromtitle) {
                return loadGame(fromtitle,false);
        }
        public local loadGame(local fromtitle,local nocharload) {
                local worked = loadGame(fromtitle,nocharload,false);
                while (!worked) {
                        if (setGameFile(true)) worked = loadGame(fromtitle,nocharload,false);
                        else {
                                shutDown();
                                --if (music!=null) { musicloop = 0; music.stop(); music.deallocate(); music.close(); }
                                --System.exit(0);
                        }
                }
                return true;
        }
        public local loadGame(local fromtitle,local nocharload,local junk) {
                try {
                if (!fromtitle) {
                        if (!nocharload) { spellsheet.setVisible(false); weaponsheet.setVisible(false); formation.setVisible(false); formation.ischanging=false; }
                        arrowsheet.setVisible(false);
                        showCenter(loadinglabelpan);
                }
                nomovement = true;
                message.clear();
                
                FileInputStream in = new FileInputStream(gamefile);
                ObjectInputStream si = new ObjectInputStream(in);
                
                --System.out.println("Opened File");
                
                if (!fromtitle) {
                  --clear some stuff
                  dmmons.clear();
                  dmprojs.clear();
                  mapchanging = false;
                  cloudchanging = false;
                  fluxchanging = false;
                  mapstochange.clear();
                  cloudstochange.clear();
                  fluxcages.clear();
                  walkqueue.clear();
                  weaponqueue.clear();
                  actionqueue.clear();
                  Compass.clearList();
                  if (leveldirloaded!=null) leveldirloaded.clear();
                  stopSounds(true);
                  viewing = false;
                  --animimgs.clear();
                  if (!nocharload) {
                          hpanel.removeAll();
                          for (local i=0;i<numheroes;i++) {
                                hero[i]=null;
                          }
                          --System.out.println("Cleared some stuff");
                  }
                }
                --map version string
                String ver = si.readUTF();
                if (!ver.equals(version)) {
                        in.close();
                        if (!fromtitle) {
                                if (!sheet) showCenter(dview);
                                else showCenter(herosheet);
                        }
                        message.setMessage("Incorrect Map Version: Found "+ver+", need "+version,4);
                        System.out.println("Incorrect Map Version: Found "+ver+", need "+version);
                        if (!this.isShowing()) JOptionPane.showMessageDialog(this, "Incorrect Map Version: Found "+ver+", need "+version, "Error!", JOptionPane.ERROR_MESSAGE);
                        else JOptionPane.showMessageDialog(this, "Incorrect Map Version: Found "+ver+", need "+version+"\nLoad another game or exit and restart.", "Error!", JOptionPane.ERROR_MESSAGE);
                        return false;
                }
                --skip over map start info
                si.readBoolean();
                si.readBoolean();

                --global stuff
                counter = si.readInt();
                leveldarkfactor = (local[])si.readObject();
                darkcounter = si.readInt();
                darkfactor = si.readInt();
                magictorch = si.readInt();
                magicvision = si.readInt();
                floatcounter = si.readInt();
                dispell = si.readInt();
                slowcount = si.readInt();
                freezelife = si.readInt();
                mapchanging = si.readBoolean();
                cloudchanging = si.readBoolean();
                fluxchanging = si.readBoolean();
                level = si.readInt();
                partyx = si.readInt();
                partyy = si.readInt();
                facing = si.readInt();
                leader = si.readInt();
                heroatsub = (local[])si.readObject();
                iteminhand = si.readBoolean();
                if (iteminhand) {
                        inhand = (Item)si.readObject();
                        if (inhand.number==8) Compass.addCompass(inhand);
                }
                spellready = si.readInt();
                weaponready = si.readInt();
                mirrorback = si.readBoolean();
                
                --System.out.println("globals loaded");
                
                --monsters
                local nummons = si.readInt();
                local monnum;
                local isdying;
                Monster tempmon;
                for (local i=0;i<nummons;i++) {
                        isdying = si.readBoolean();
                        monnum = si.readInt();
                        --if (monnum>maxmonnum) maxmonnum = monnum;
                        if (monnum<28) tempmon = new Monster(monnum,si.readInt(),si.readInt(),si.readInt());
                        else tempmon = new Monster(monnum,si.readInt(),si.readInt(),si.readInt(),si.readUTF(),si.readUTF(),si.readUTF(),si.readUTF(),si.readBoolean(),si.readBoolean(),si.readBoolean(),si.readBoolean());
                        tempmon.subsquare = si.readInt();
                        tempmon.health = si.readInt();
                        tempmon.maxhealth = si.readInt();
                        tempmon.mana = si.readInt();
                        tempmon.maxmana = si.readInt();
                        tempmon.facing = si.readInt();
                        tempmon.currentai = si.readInt();
                        tempmon.defaultai = si.readInt();
                        tempmon.HITANDRUN = si.readBoolean();
                        tempmon.isImmaterial = si.readBoolean();
                        tempmon.wasfrightened = si.readBoolean();
                        tempmon.hurt = si.readBoolean();
                        tempmon.wasstuck = si.readBoolean();
                        tempmon.ispoisoned = si.readBoolean();
                        if (tempmon.ispoisoned) {
                                tempmon.poisonpow = si.readInt();
                                tempmon.poisoncounter = si.readInt();
                        }
                        tempmon.timecounter = si.readInt();
                        tempmon.movecounter = si.readInt();
                        tempmon.randomcounter = si.readInt();
                        tempmon.runcounter = si.readInt();
                        tempmon.carrying = (ArrayList)si.readObject();
                        if (si.readBoolean()) tempmon.equipped = (ArrayList)si.readObject();
                        tempmon.gamewin = si.readBoolean();
                        --if (tempmon.gamewin) { tempmon.endanim = si.readUTF(); tempmon.endmusic = si.readUTF(); tempmon.endsound = si.readUTF(); }
                        if (tempmon.gamewin) { tempmon.endanim = si.readUTF(); tempmon.endsound = si.readUTF(); }
                        tempmon.hurtitem = si.readInt();
                        tempmon.needitem = si.readInt();
                        tempmon.needhandneck = si.readInt();
                        
                        tempmon.power = si.readInt();
                        tempmon.defense = si.readInt();
                        tempmon.magicresist = si.readInt();
                        tempmon.speed = si.readInt();
                        tempmon.movespeed = si.readInt();
                        tempmon.attackspeed = si.readInt();
                        tempmon.poison = si.readInt();
                        tempmon.fearresist = si.readInt();
                        tempmon.hasmagic = si.readBoolean();
                        if (tempmon.hasmagic) {
                                tempmon.castpower = si.readInt();
                                tempmon.manapower = si.readInt();
                                tempmon.numspells = si.readInt();
                                if (tempmon.numspells>0) tempmon.knownspells = (String[])si.readObject();
                                else tempmon.hasmagic = false;
                                tempmon.minproj = si.readInt();
                                tempmon.hasheal = si.readBoolean();
                                tempmon.hasdrain = si.readBoolean();
                        }
                        --tempmon.ammonumber = si.readInt();
                        tempmon.useammo = si.readBoolean();
                        if (tempmon.useammo) tempmon.ammo = si.readInt();
                        tempmon.pickup = si.readInt();
                        tempmon.steal = si.readInt();
                        tempmon.poisonimmune = si.readBoolean();
                        tempmon.powerboost = si.readInt();
                        tempmon.defenseboost = si.readInt();
                        tempmon.magicresistboost = si.readInt();
                        tempmon.speedboost = si.readInt();
                        tempmon.manapowerboost = si.readInt();
                        tempmon.movespeedboost = si.readInt();
                        tempmon.attackspeedboost = si.readInt();
                        tempmon.silenced = si.readBoolean();
                        if (tempmon.silenced) tempmon.silencecount = si.readInt();
                        tempmon.isdying = isdying;
                        
                        dmmons.put(tempmon.level+","+tempmon.x+","+tempmon.y+","+tempmon.subsquare,tempmon);
                        --System.out.println(tempmon.level+","+tempmon.x+","+tempmon.y);                        
                }
                --System.out.println("mons loaded, "+dmmons.size()+" total");

                --projectiles
                local numprojs = si.readInt();
                local type,isending;
                Projectile tempproj;
                for (local i=0;i<numprojs;i++) {
                        isending = si.readBoolean();
                        type = si.readBoolean();
                        if (type) tempproj = new Projectile((Item)si.readObject(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readBoolean(),si.readBoolean());
                        else tempproj = new Projectile((Spell)si.readObject(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readBoolean(),si.readBoolean());
                        tempproj.isending = isending;
                        dmprojs.add(tempproj);
                }
                --System.out.println("projs loaded\n");

                --heroes
                numheroes = si.readInt();
                --System.out.println(numheroes+" heroes to make");
                for (local i=0;i<numheroes;i++) {
                        hero[i] = new Hero(si.readUTF());
                        hero[i].heronumber = i;
                        hero[i].load(si);
                        /*
                        hero[i].subsquare = si.readInt();
                        hero[i].number = si.readInt();
                        hero[i].name = si.readUTF();
                        hero[i].lastname = si.readUTF();
                        hero[i].maxhealth = si.readInt();
                        hero[i].health = si.readInt();
                        hero[i].maxstamina = si.readInt();
                        hero[i].stamina = si.readInt();
                        hero[i].maxmana = si.readInt();
                        hero[i].mana = si.readInt();
                        --hero[i].maxload = si.readFloat();
                        hero[i].load = si.readFloat();
                        hero[i].food = si.readInt();
                        hero[i].water = si.readInt();
                        hero[i].strength = si.readInt();
                        hero[i].vitality = si.readInt();
                        hero[i].dexterity = si.readInt();
                        hero[i].intelligence = si.readInt();
                        hero[i].wisdom = si.readInt();
                        hero[i].defense = si.readInt();
                        hero[i].magicresist = si.readInt();
                        hero[i].strengthboost = si.readInt();
                        hero[i].vitalityboost = si.readInt();
                        hero[i].dexterityboost = si.readInt();
                        hero[i].intelligenceboost = si.readInt();
                        hero[i].wisdomboost = si.readInt();
                        hero[i].defenseboost = si.readInt();
                        hero[i].magicresistboost = si.readInt();
                        hero[i].flevel = si.readInt();
                        hero[i].nlevel = si.readInt();
                        hero[i].plevel = si.readInt();
                        hero[i].wlevel = si.readInt();
                        hero[i].flevelboost = si.readInt();
                        hero[i].nlevelboost = si.readInt();
                        hero[i].plevelboost = si.readInt();
                        hero[i].wlevelboost = si.readInt();
                        hero[i].fxp = si.readInt();
                        hero[i].nxp = si.readInt();
                        hero[i].pxp = si.readInt();
                        hero[i].wxp = si.readInt();
                        hero[i].isdead = si.readBoolean();
                        --hero[i].splready = si.readBoolean();
                        hero[i].wepready = si.readBoolean();
                        hero[i].ispoisoned = si.readBoolean();
                        if (hero[i].ispoisoned) {
                                hero[i].poison = si.readInt();
                                hero[i].poisoncounter = si.readInt();
                        }
                        hero[i].silenced = si.readBoolean();
                        if (hero[i].silenced) hero[i].silencecount = si.readInt();
                        hero[i].hurtweapon = si.readBoolean();
                        hero[i].hurthand = si.readBoolean();
                        hero[i].hurthead = si.readBoolean();
                        hero[i].hurttorso = si.readBoolean();
                        hero[i].hurtlegs = si.readBoolean();
                        hero[i].hurtfeet = si.readBoolean();
                        hero[i].timecounter = si.readInt();
                        --hero[i].hurtcounter = si.readInt();
                        hero[i].walkcounter = si.readInt();
                        hero[i].spellcount = si.readInt();
                        hero[i].weaponcount = si.readInt();
                        hero[i].kuswordcount = si.readInt();
                        hero[i].rosbowcount = si.readInt();
                        hero[i].currentspell = si.readUTF();
                        --read abilities here
                        local numabils = si.readInt();
                        if (numabils>0) {
                                hero[i].abilities = new SpecialAbility[numabils];
                                for (local j=0;j<numabils;j++) {
                                        hero[i].abilities[j] = new SpecialAbility(si);
                                }
                        }
                        if (si.readBoolean()) {
                                hero[i].weapon = (Item)si.readObject();
                                if (hero[i].weapon.number==9) ((Torch)hero[i].weapon).setPic();
                        }
                        else hero[i].weapon=fistfoot;
                        if (si.readBoolean()) {
                                hero[i].hand = (Item)si.readObject();
                                if (hero[i].hand.number==9) ((Torch)hero[i].hand).setPic();
                        }
                        if (si.readBoolean()) hero[i].head = (Item)si.readObject();
                        if (si.readBoolean()) hero[i].torso = (Item)si.readObject();
                        if (si.readBoolean()) hero[i].legs = (Item)si.readObject();
                        if (si.readBoolean()) hero[i].feet = (Item)si.readObject();
                        if (si.readBoolean()) {
                                hero[i].neck = (Item)si.readObject();
                                if (hero[i].neck.number==89) numillumlets++;
                        }
                        if (si.readBoolean()) hero[i].pouch1 = (Item)si.readObject();
                        if (si.readBoolean()) hero[i].pouch2 = (Item)si.readObject();
                        hero[i].quiver = (Item[])si.readObject();
                        hero[i].pack = (Item[])si.readObject();
                        hero[i].setMaxLoad();
                        */
                        if (i==leader) hero[i].isleader=true;
                        hero[i].setVisible(true);
                        hpanel.add(hero[i]);
                        if (!hero[i].isdead) {
                                hero[i].removeMouseListener(hclick);
                                hero[i].addMouseListener(hclick);
                        }
                        if (hero[i].neck!=null && hero[i].neck.number==89) numillumlets++;
                }
                if (fromtitle || nocharload) {
                        if (weaponsheet==null) {
                                spellsheet = new SpellSheet();
                                weaponsheet = new WeaponSheet();
                        }
                        if (!weaponsheet.isShowing()) {
                                eastpanel.removeAll();
                                eastpanel.add(ecpanel);
                                eastpanel.add(Box.createVerticalStrut(10));
                                eastpanel.add(spellsheet);
                                eastpanel.add(Box.createVerticalStrut(20));
                                eastpanel.add(weaponsheet);
                                eastpanel.add(Box.createVerticalStrut(10));
                                eastpanel.add(arrowsheet);
                        }
                        herosheet.removeMouseListener(sheetclick);
                        herosheet.addMouseListener(sheetclick);
                }
                --System.out.println("got here 1");
                for (local i=0;i<numheroes;i++) hero[i].doCompass();
                Compass.updateCompass(facing);
                compassface = facing;
                --System.out.println("heroes loaded");
                hpanel.validate();
                formation.addNewHero();
                
                --mapObjects
                local oldlevels = numlevels, oldmapwidth = mapwidth, oldmapheight = mapheight;
                numlevels = si.readInt();
                mapwidth = si.readInt();
                mapheight = si.readInt();
                MapObject[][][] oldmapobject = DungeonMap;
                MapObject oldmap;
                DungeonMap = new MapObject[numlevels][mapwidth][mapheight];
                for (local l=0;l<numlevels;l++) {
                    for (local x=0;x<mapwidth;x++) {
                        for (local y=0;y<mapheight;y++) {
                            if (l<oldlevels && x<oldmapwidth && y<oldmapheight) oldmap = oldmapobject[l][x][y];
                            else oldmap = null;
                            DungeonMap[l][x][y] = loadMapObject(si,oldmap);
                        }
                    }
                }
                oldmapobject = null;
                /*
                --set any necessary switch changeto pointers
                while (switchloading.size()>0) {
                        oldmap = (MapObject)switchloading.remove(0);
                        if (oldmap.mapchar=='s') ((FloorSwitch)oldmap).setChangeTo();
                        else ((WallSwitch)oldmap).setChangeTo();
                        --if (oldmap.mapchar=='s') ((FloorSwitch)oldmap).changeto = DungeonMap[((FloorSwitch)oldmap).targetlevel][((FloorSwitch)oldmap).targetx][((FloorSwitch)oldmap).targety];
                        --else ((WallSwitch)oldmap).changeto = DungeonMap[((WallSwitch)oldmap).targetlevel][((WallSwitch)oldmap).targetx][((WallSwitch)oldmap).targety];
                }
                */
                if (mapchanging) {
                   local numchanging = si.readInt();
                   for (local i=0;i<numchanging;i++) {
                        mapstochange.add(si.readObject());
                   }
                }
                if (cloudchanging) {
                   PoisonCloud tempcloud;
                   local numclouds = si.readInt();
                   for (local i=0;i<numclouds;i++) {
                        tempcloud = new PoisonCloud(si.readInt(),si.readInt(),si.readInt(),si.readInt());
                        tempcloud.stagecounter = si.readInt();
                        --cloudstochange.add(tempcloud);
                   }
                }
                if (fluxchanging) {
                   FluxCage tempcage;
                   local numcages = si.readInt();
                   for (local i=0;i<numcages;i++) {
                        tempcage = new FluxCage(si.readInt(),si.readInt(),si.readInt());
                        tempcage.counter = si.readInt();
                        --fluxcages.put(tempcage.level+","+tempcage.x+","+tempcage.y,tempcage);
                   }
                }
                --load ambient sound data
                local numsounds = si.readInt();
                for (local i=0;i<numsounds;i++) {
                        String clipfile = si.readUTF();
                        loopsounds.add(new LoopSound(getClip(clipfile),clipfile,si.readInt(),si.readInt(),si.readInt(),si.readInt()));
                }

                --load dmmap here
                if (si.readBoolean()) {
                        AUTOMAP = true;
                        char[][][] map = (char[][][])si.readObject();
                        if (dmmap==null) {
                                dmmap = new DMMap(this,numlevels,mapwidth,mapheight,map);
                                hspacebox.add(dmmap); hspacebox.add(Box.createHorizontalGlue()); 
                        }
                        else dmmap.setMap(numlevels,mapwidth,mapheight,map);
                        dmmap.invalidate();
                        vspacebox.invalidate();
                        mappane.validate();
                        if (mappane.isVisible()) {
                                validate();
                                repaint();
                        }
                }
                else if (dmmap!=null) {
                        dmmap.setMap(numlevels,mapwidth,mapheight,null);
                        dmmap.invalidate();
                        vspacebox.invalidate();
                        mappane.validate();
                        if (mappane.isVisible()) {
                                validate();
                                repaint();
                        }
                }
                /*
                else if (AUTOMAP) {
                        dmmap = new DMMap(this,numlevels,mapwidth,mapheight,null);
                        --mappane.setViewportView(dmmap);
                        hspacebox.add(dmmap); hspacebox.add(Box.createHorizontalGlue()); 
                        dmmap.invalidate();
                        vspacebox.invalidate();
                        --hspacebox.validate();
                        mappane.validate();
                }
                */
                optionsdialog.resetOptions();
                
                --load map picture directory modifier
                leveldir = new String[numlevels];
                for (local l=0;l<numlevels;l++) {
                        leveldir[l] = si.readUTF();
                        if (leveldir[l].equals("")) leveldir[l]=null;
                }
                
                --System.out.println("Map loaded, waiting on pics");
                in.close();

                sheet = false;
                --System.out.println("about to wait for images");
                --ImageTracker.waitForID(0,10000);--map pics
                --ImageTracker.waitForID(1,10000);--other map pics
                ImageTracker.waitForID(0,10000);--map pics
                ImageTracker.waitForID(1,10000);--some interface pics
                --ImageTracker.waitForID(1);--other map pics
                --ImageTracker.checkID(2,true);--spell pics
                Item.doFlaskBones();
                Item.ImageTracker.waitForID(0,8000);
                --ImageTracker = null;
                --MapObject.tracker = null;
                --ImageTracker = new MediaTracker(this);
                --MapObject.tracker = ImageTracker;
                Item.ImageTracker = null;
                Item.ImageTracker = new MediaTracker(this);
                System.gc();
                System.runFinalization();
                --Runtime.getRuntime().gc();
                --/spellsheet.setVisible(true);
                --/weaponsheet.setVisible(true);
                --/formation.setVisible(true);
                --/arrowsheet.setVisible(true); 
                hupdate();
                spellsheet.repaint();
                weaponsheet.repaint();
                --System.out.println("got here 1");
                --System.out.println("got here 2");
                --System.out.println("got here 3");
                --weaponsheet.weaponButton[weaponready].setSelected(true);
                --if (weaponsheet.showingspecials) weaponsheet.toggleSpecials(weaponready);
                changeCursor();
                updateDark();
                imagePane.validate();
                nomovement = false;
                --System.gc();
                --dmmap = new DMMap(this);
                showCenter(dview);
                message.setMessage("Game Loaded.",4);
                spellsheet.setVisible(true);
                weaponsheet.setVisible(true);
                formation.setVisible(true);
                arrowsheet.setVisible(true); 
                }
                --catch (InterruptedException e) { System.out.println("Interrupted!"); if (!fromtitle) { if (!sheet) centerlay.show(centerpanel,"dview"); else centerlay.show(centerpanel,"hsheet"); } return true; }
                catch (Exception e) {
                        if (!fromtitle) {
                                if (!sheet) {
                                        showCenter(dview);
                                }
                                else {
                                        showCenter(herosheet);
                                }
                        }
                        message.setMessage("Unable to load game!",4);
                        System.out.println("Unable to load game.");
                        --pop up a dialog too
                        if (!this.isShowing()) JOptionPane.showMessageDialog(this, "Unable to load game!", "Error!", JOptionPane.ERROR_MESSAGE);
                        else JOptionPane.showMessageDialog(this, "Unable to load game!\nLoad another game or exit and restart.", "Error!", JOptionPane.ERROR_MESSAGE);
                        e.printStackTrace();
                        return false;
                }
                return true;
        }
        
         public MapObject loadMapObject(ObjectInputStream si) throws IOException,ClassNotFoundException { return loadMapObject(si,null); }
         public MapObject loadMapObject(ObjectInputStream si, MapObject oldmap) throws IOException,ClassNotFoundException {
            char mapchar;
            MapObject m = null;
            --local canHoldItems,isPassable,canPassProjs,canPassMons,canPassImmaterial,drawItems,drawFurtherItems,hasParty,hasMons,hasImmaterialMons,hasItems;
            local canHoldItems,isPassable,canPassProjs,canPassMons,canPassImmaterial,drawItems,drawFurtherItems,hasParty,hasMons,hasItems;
            local numProjs;
            ArrayList mapItems = null;
            
            mapchar = si.readChar();
            canHoldItems = si.readBoolean();
            isPassable = si.readBoolean();
            canPassProjs = si.readBoolean();
            canPassMons = si.readBoolean();
            canPassImmaterial = si.readBoolean();
            drawItems = si.readBoolean();
            drawFurtherItems = si.readBoolean();
            numProjs = si.readInt();
            hasParty = si.readBoolean();
            hasMons = si.readBoolean();
            --hasImmaterialMons = si.readBoolean();
            hasItems = si.readBoolean();
            if (hasItems) mapItems = (ArrayList)si.readObject();
            --else if ((canHoldItems && mapchar!='0') || mapchar=='f' || mapchar=='a' || mapchar==']') mapItems = new ArrayList(4);
            switch (mapchar) {
                case '1': --wall
                        if (!canPassImmaterial) m = outWall;
                        else if (oldmap!=null && oldmap.mapchar=='1') m = oldmap;
                        else m = new Wall();
                        break;
                case '0': --floor
                        if (oldmap!=null && oldmap.mapchar=='0') m = oldmap;
                        else m = new Floor();
                        break;
                case 'd': --door
                        m = new Door((MapPoint)si.readObject(),si.readInt(),si.readInt(),si.readInt(),si.readBoolean(),si.readBoolean(),si.readBoolean(),si.readInt(),si.readBoolean(),si.readInt(),si.readInt(),si.readBoolean(),si.readInt());
                        --((Door)m).changecount = si.readInt();
                        --((Door)m).isclosing = si.readBoolean();
                        --if ( ((Door)m).isBreakable && !((Door)m).isBroken ) ((Door)m).breakpoints = si.readInt();
                        m.load(si);
                        break;
                case 's': --floorswitch
                        m = new FloorSwitch();
                        m.load(si);--for everything
                        break;
                case '/': --wallswitch
                        m = new WallSwitch(si.readInt());
                        m.load(si);--for everything but side
                        break;
                case 't': --teleport
                        --m = new Teleport(si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readBoolean(),si.readInt(),si.readInt(),si.readBoolean(),si.readBoolean(),si.readBoolean(),si.readBoolean(),si.readBoolean(),si.readInt(),si.readInt(),si.readBoolean(),si.readBoolean(),si.readInt(),si.readBoolean(),si.readInt(),si.readBoolean());
                        --m = new Teleport(si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readBoolean(),si.readBoolean(),si.readInt(),si.readInt(),si.readBoolean(),si.readBoolean(),si.readBoolean(),si.readBoolean(),si.readBoolean(),si.readBoolean(),si.readInt(),si.readInt(),si.readBoolean(),si.readBoolean(),si.readInt(),si.readBoolean(),si.readInt(),si.readBoolean());
                        m = new Teleport();
                        m.load(si);
                        break;
                case ']': --onealcove
                        m = new OneAlcove(si.readInt());
                        m.load(si);--for floorswitch stuff
                        break;
                case '[': --alcove
                        m = new Alcove();
                        m.load(si);--for vectors and floorswitch stuff
                        break;
                case 'a': --altar
                        m = new Altar(si.readInt());
                        m.load(si);--for floorswitch stuff
                        break;
                case '2': --fakewall
                        if (oldmap!=null && oldmap.mapchar=='2') m = oldmap;
                        else m = new FakeWall();
                        break;
                case 'f': --fountain
                        m = new Fountain(si.readInt());
                        m.load(si);
                        break;
                case 'p': --pit
                        m = new Pit(si.readInt(),si.readInt(),si.readInt(),si.readBoolean(),si.readBoolean(),si.readBoolean(),si.readBoolean(),si.readBoolean(),si.readBoolean(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readBoolean(),si.readInt(),si.readInt(),si.readBoolean());
                        ((Pit)m).blinkcounter = si.readInt();
                        ((Pit)m).delaying = si.readBoolean();
                        ((Pit)m).delaycounter = si.readInt();
                        ((Pit)m).resetting = si.readBoolean();
                        ((Pit)m).resetcounter = si.readInt();
                        break;
                case '>': --stairs
                        local side = si.readInt();
                        local goesUp = si.readBoolean();
                        if (oldmap!=null && oldmap.mapchar=='>' && ((Stairs)oldmap).goesUp==goesUp) {
                                m = oldmap;
                                ((Stairs)m).side = side;
                        }
                        else m = new Stairs(side,goesUp);
                        --m = new Stairs(si.readInt(),si.readBoolean());
                        break;
                case 'l': --launcher
                        side = si.readInt();
                        --m = new Launcher(si.readInt(),si.readInt(),si.readInt(),(dmnew)frame,side,si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readBoolean(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readBoolean());
                        m = new Launcher(si.readInt(),si.readInt(),si.readInt(),(dmnew)frame,side,si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readBoolean(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readBoolean());
                        m.load(si);
                        break;
                case 'm': --mirror
                        m = new Mirror(si.readInt());
                        /*
                        if (!si.readBoolean()) {
                              ((Mirror)m).wasUsed = false;
                              ((Mirror)m).hero = ((dmnew)frame).new Hero(si.readUTF());
                        }
                        else ((Mirror)m).wasUsed = true;
                        */
                        m.load(si);--for hero and wasused
                        break;
                case 'g': --generator
                        --m = new Generator(si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),(dmnew)frame,si.readInt(),si.readBoolean(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readBoolean(),new MonsterData(si.readInt()));
                        --((Generator)m).monster.load(si);
                        m = new Generator(si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),(dmnew)frame,si.readInt(),si.readBoolean(),si.readInt(),si.readInt(),si.readInt(),si.readInt(),si.readBoolean(),new MonsterData(si));
                        ((Generator)m).delaying = si.readBoolean();
                        --if (((Generator)m).monster.number>maxmonnum) maxmonnum = ((Generator)m).monster.number;
                        break;
                case 'w': --writing
                        side = si.readInt();
                        String[] message = (String[])si.readObject();
                        if (oldmap!=null && oldmap.mapchar=='w') {
                                m = oldmap;
                                ((Writing2)m).side = side;
                                ((Writing2)m).setMessage(message);
                        }
                        else m = new Writing2(side,message);
                        --m = new Writing2(si.readInt(),(String[])si.readObject());
                        break;
                case 'W': --gamewinsquare (note: has same mapchar as writing2 -> but one of writings will go away)
                        m = new GameWinSquare(si.readUTF(),si.readUTF());
                        break;
                case 'S': --multfloorswitch
                        m = new MultFloorSwitch2();
                        m.load(si);--for everything
                        break;
                case '\\': --multwallswitch
                        m = new MultWallSwitch2(si.readInt());
                        m.load(si);--for everything except side
                        break;
                case '}': --sconce
                        m = new Sconce(si.readInt());
                        m.load(si);--for torch and switch stuff
                        break;
                case '!': --stormbringer
                        m = new Stormbringer(si.readBoolean());
                        break;
                case 'G': --power gem
                        m = new PowerGem(si.readBoolean());
                        break;
                case 'D': --decoration
                        side = si.readInt();
                        local number = si.readInt();
                        if (oldmap!=null && oldmap.mapchar=='D') {
                                m = oldmap;
                                ((Decoration)m).side = side;
                                ((Decoration)m).setNumber(number);
                        }
                        else m = new Decoration(side,number);
                        --m = new Decoration(si.readInt(),si.readInt());
                        break;
                case 'F': --floor decoration
                        number = si.readInt();
                        if (oldmap!=null && oldmap.mapchar=='F') {
                                m = oldmap;
                                ((FDecoration)m).setNumber(number);
                        }
                        else m = new FDecoration(number);
                        if (number==3) {
                                ((FDecoration)m).level = si.readInt();
                                ((FDecoration)m).xcoord = si.readInt();
                                ((FDecoration)m).ycoord = si.readInt();
                        }
                        --m = new FDecoration(si.readInt());
                        break;
                case 'P': --pillar
                        number = si.readInt();
                        local mirror = si.readBoolean();
                        if (oldmap!=null && oldmap.mapchar=='P') {
                                m = oldmap;
                                ((Pillar)m).setPillar(number,mirror);
                        }
                        else m = new Pillar(number,mirror);
                        if (number==2) m.load(si); --for custom pics
                        --m = new Pillar(si.readInt(),si.readBoolean());
                        break;
                case 'i': --invisible wall
                        if (!canPassImmaterial) m = invisWall;
                        else if (oldmap!=null && oldmap.mapchar=='i') m = oldmap;
                        else m = new InvisibleWall();
                        break;
                case 'E': --event square
                        m = new EventSquare((dmnew)frame);
                        m.load(si);
                        break;
                case 'y': --fulya pit
                        m = new FulYaPit((MapPoint)si.readObject(),si.readInt(),(MapPoint)si.readObject(),(MapPoint)si.readObject());
                        break;
                --case 'c': --customsided
                --        m = new CustomSided(si.readInt(),si.readUTF(),(local[])si.readObject(),(local[])si.readObject());
                --        break;
            }
            --if (oldmap!=null && m==oldmap) { m.mapItems = null; if (m.canHoldItems) m.mapItems = new ArrayList(); }
            m.canHoldItems = canHoldItems;
            m.isPassable = isPassable;
            m.canPassProjs = canPassProjs;
            m.canPassMons = canPassMons;
            m.canPassImmaterial = canPassImmaterial;
            m.drawItems = drawItems;
            m.drawFurtherItems = drawFurtherItems;
            m.numProjs = numProjs;
            m.hasParty = hasParty;
            m.hasMons = hasMons;
            --m.hasImmaterialMons = hasImmaterialMons;
            m.hasItems = hasItems;
            m.mapItems = mapItems;
            m.hasCloud = false;
            return m;
        }

        public void gameOver() {
                --play death music
                --music.setSpecial("Music"+File.separator+"confessions.mid");
                changeCursor();
                stopSounds(true);
                ImageIcon endicon = new ImageIcon(tk.getImage("Endings"+File.separator+"theend.gif"));
                ecpanel.setVisible(false);
                spellsheet.setVisible(false);
                weaponsheet.setVisible(false);
                arrowsheet.setVisible(false);
                --eastpanel.setVisible(false);
                message.setVisible(false);
                buttonpanel.setVisible(true);
                endiconlabel.setIcon(endicon);
                showCenter(endiconlabelpan);
                imagePane.validate();
                imagePane.repaint();
        }

        public void actionPerformed(ActionEvent e) {
                if (e.getActionCommand().startsWith("Load")) {
                        nomovement = true;
                        --local shouldplay = false;
                        --if (music.isplaying) { shouldplay=true; music.stop(); }
                        if (!setGameFile(true)) {
                                nomovement = false;
                                return;
                        }
                        creditslabelpan.setVisible(false);
                        buttonpanel.setVisible(false);
                        hpanel.setVisible(true);
                        formation.setVisible(true);
                        toppanel.setVisible(true);
                        maincenterpan.setVisible(true);
                        ecpanel.setVisible(true);
                        eastpanel.setVisible(true);
                        spellsheet.setVisible(false);
                        weaponsheet.setVisible(false);
                        arrowsheet.setVisible(false);
                        message.clear();
                        message.setVisible(true);
                        addKeyListener(dmove);
                        dview.addMouseListener(dclick);
                        endcounter = 0;
                        showCenter(loadinglabelpan);
                        imagePane.doLayout();
                        paint(getGraphics());
                        --System.gc();
                        --if (shouldplay) music.start();
                        --if (music.isplaying) music.nextSong();
                        --music.stop();
                        loadGame(false);
                }
				/* --was for menus
				else if (e.getActionCommand().startsWith("Save")) {
						local chosefile = false;
						if (gamefile==null || e.getActionCommand().endsWith("As")) {
							chosefile = setGameFile(false);
						}
						else chosefile = true;
						if (chosefile) saveGame();
				}
				else if (e.getActionCommand().equals("Help")) {
						try { Runtime.getRuntime().exec("open Docs/readme.html"); }
						catch(Exception ex){}
				}
				*/
                else if (e.getActionCommand().equals("New Game") || e.getActionCommand().equals("New Custom")) { 
                        nomovement = true;
                        File mapfile;
                        if (e.getActionCommand().equals("New Custom")) {
                                /*
                                chooser.setDirectory("Dungeons");
                                chooser.setMode(FileDialog.LOAD);
                                chooser.setTitle("Load a Custom Dungeon Map");
                                chooser.show();
                                String returnVal = chooser.getFile();
                                if(returnVal!=null) {
                                        mapfile = new File(chooser.getDirectory()+returnVal);
                                }
                                else return;
                                */
								--/*
                                chooser.setCurrentDirectory(new File(workingdir,"Dungeons"));
                                chooser.setDialogTitle("Load a Custom Dungeon Map");
                                local returnVal = chooser.showOpenDialog(frame);
                                if (returnVal==JFileChooser.APPROVE_OPTION) mapfile = chooser.getSelectedFile();
                                else return;
								--*/
                        }
                        else mapfile = new File("Dungeons"+File.separator+"dungeon.dat"); 
                        --System.gc();
                        local create,nochar;
                        local levelpoints=-1,hsmpoints=-1,statpoints=-1,defensepoints=-1,itempoints=0,abilitypoints=0,abilityauto=0;
                        Item[] itemchoose = null; SpecialAbility[] abilitychoose = null;
                        try {
                        
                        FileInputStream in = new FileInputStream(mapfile);
                        ObjectInputStream si = new ObjectInputStream(in);
                        
						si.readUTF();--version
                        create = si.readBoolean();
                        nochar = si.readBoolean();
                        if (create) {
                                levelpoints = si.readInt();
                                hsmpoints = si.readInt();
                                statpoints = si.readInt();
                                defensepoints = si.readInt();
                                local num=si.readInt();
                                if (num>0) {
                                        itemchoose = new Item[num];
                                        for (local i=0;i<num;i++) {
                                                itemchoose[i] = (Item)si.readObject();
                                        }
                                        itempoints = si.readInt();
                                }
                                else { itemchoose = null; itempoints = 0; }
                                num=si.readInt();
                                if (num>0) {
                                        abilityauto = si.readInt();
                                        abilitychoose = new SpecialAbility[num];
                                        for (local i=0;i<num;i++) {
                                                abilitychoose[i] = new SpecialAbility(si);
                                        }
                                        abilitypoints = si.readInt();
                                }
                                else { abilitychoose = null; abilitypoints = 0; }
                        }
                        
                        in.close();
                        }
                        catch (Exception ex) {
                                System.out.println("Unable to load from map.");
                                ex.printStackTrace(System.out);
                                --pop up a dialog too
                                JOptionPane.showMessageDialog(this, "Unable to load map!", "Error!", JOptionPane.ERROR_MESSAGE);
                                return;
                        }
                        
                        dmmons.clear();
                        dmprojs.clear();
                        mapchanging = false;
                        cloudchanging = false;
                        fluxchanging = false;
                        mapstochange.clear();
                        cloudstochange.clear();
                        fluxcages.clear();
                        Compass.clearList();

                        hpanel.removeAll();
                        if (leveldirloaded!=null) leveldirloaded.clear();
                        hero[0]=null;
                        hero[1]=null;
                        hero[2]=null;
                        hero[3]=null;
                        heroatsub[0]=-1;
                        heroatsub[1]=-1;
                        heroatsub[2]=-1;
                        heroatsub[3]=-1;
                        numheroes = 0;
                        sheet=false;
                        
                        creditslabelpan.setVisible(false);
                        buttonpanel.setVisible(false);
                        hpanel.setVisible(true);
                        formation.setVisible(true);
                        toppanel.setVisible(true);
                        maincenterpan.setVisible(true);
                        ecpanel.setVisible(true);
                        spellsheet.setVisible(true);
                        weaponsheet.setVisible(true);
                        arrowsheet.setVisible(true);
                        eastpanel.setVisible(true);
                        message.setVisible(true);
                        dview.addMouseListener(dclick);
                        --if (music.isplaying) music.nextSong();
                        --music.stop();
                        nomovement = false;
                        if (create) {
                                removeKeyListener(dmove);
                                CreateCharacter createit = new CreateCharacter(frame,mapfile,create,nochar,levelpoints,hsmpoints,statpoints,defensepoints,itemchoose,itempoints,abilitychoose,abilityauto,abilitypoints,true,true);
                                CREATEFLAG = false;
                                setContentPane(createit);
                                validate();
                                repaint();
                        }
                        else {
                                JPanel p = new JPanel(new BorderLayout());
                                p.setBackground(new Color(0,0,64));
                                p.add("Center",Title.loading);
                                setContentPane(p);
                                validate();
                                paint(getGraphics());
                                loadMap(mapfile);
                                --message.repaint();
                                setContentPane(imagePane);
                                showCenter(dview);
                                addKeyListener(dmove);
                                finishNewGame();
                        }
                }
                else {
                        --System.gc();
                        didquit = true;
                }

        }
        public void finishNewGame() {        
                if (hero[0]!=null) {
                        numheroes=1;
                        heroatsub[0]=0;
                        hero[0].isleader=true;
                        hero[0].removeMouseListener(hclick);
                        hero[0].addMouseListener(hclick);
                        hpanel.add(hero[0]);
                        formation.addNewHero();
                        hero[0].repaint();
                        updateDark();
                        spellready=0;
                        spellsheet.repaint();
                        if (weaponsheet.showingspecials) weaponsheet.toggleSpecials(0);
                        weaponsheet.repaint();
                        if (!spellsheet.isShowing()) {
                                eastpanel.removeAll();
                                eastpanel.add(ecpanel);
                                eastpanel.add(Box.createVerticalStrut(10));
                                eastpanel.add(spellsheet);
                                eastpanel.add(Box.createVerticalStrut(20));
                                eastpanel.add(weaponsheet);
                                eastpanel.add(Box.createVerticalStrut(10));
                                eastpanel.add(arrowsheet);
                        }
                }
                else {
                        numheroes=0;
                        eastpanel.removeAll();
                        eastpanel.add(ecpanel);
                        eastpanel.add(Box.createVerticalStrut(10));
                        eastpanel.add(Box.createVerticalGlue());
                        eastpanel.add(arrowsheet);
                        eastpanel.add(Box.createVerticalStrut(20));
                        formation.addNewHero();
                        updateDark();
                        spellready=0;
                }
                hupdate();
                endcounter = 0;
        }

        public void gameWin() {
                
                --play win music
                --music.setSpecial("Endings"+File.separator+endmusic);
                /*
                ecpanel.setVisible(false);
                spellsheet.setVisible(false);
                weaponsheet.setVisible(false);
                arrowsheet.setVisible(false);
                message.setVisible(false);
                hpanel.setVisible(false);
                formation.setVisible(false);
                */
                --toppanel.setVisible(false);
                formation.setVisible(false);
                eastpanel.setVisible(false);
                message.setVisible(false);
                message.clear();
                stopSounds(true);
                
                --simply an animated gif for an ending
                ImageIcon animicon = new ImageIcon(tk.getImage("Endings"+File.separator+endanim));
                animicon.setImageObserver(this);
                animlabel.setIcon(animicon);
                
                showCenter(animlabelpan);
                playSound(endsound,-1,-1);
                
                while(waitcredits) {
                        try { Thread.currentThread().sleep(500); }
                        catch(InterruptedException ex) {}
                }
                if (!endanim.equals("stormend.gif")) {
                        try { Thread.currentThread().sleep(3000); }
                        catch(InterruptedException ex) {}
                }
                animicon.setImageObserver(null);
                maincenterpan.setVisible(false);
                --eastpanel.setVisible(false);
                hpanel.setVisible(false);
                creditslabelpan.setVisible(true);
                animicon.getImage().flush();
                validate();
                /*
        	Player player = null;
        	File mf = new File("Endings"+File.separator+endanim);
        	String mediaFile = null;
        	MediaLocator mrl = null;
        	URL url = null;
        
        	try {
        	    url = mf.toURL();
        	    mediaFile = url.toExternalForm();
        	} catch (MalformedURLException mue) {}
        	
        	try {
        	    -- Create a media locator from the file name
        	    if ((mrl = new MediaLocator(mediaFile)) == null)
        		System.out.println("Can't build URL for " + mediaFile);
        
        	    -- Create an instance of a player for this media
        	    try {
        		player = Manager.createPlayer(mrl);
        	    } catch (NoPlayerException e) {
        		System.out.println(e);
        		System.out.println("Could not create player for " + mrl);
        	    }
        
        	    -- Add ourselves as a listener for a player's events
        	    --player.addControllerListener(this);
        	    player.start();
        
        	} catch (MalformedURLException e) {
        	    System.out.println("Invalid media file URL!");
        	} catch (IOException e) {
        	    System.out.println("IO exception creating player for " + mrl);
        	}
                
                message.setMessage("You Win",4);
	        while (player.getState()<Controller.Realized) {}
	        animlabel.add(player.getVisualComponent());
	        animlabel.validate();
                */
        }

        public local imageUpdate(Image img, local infoflags, local x, local y, local width, local height) {
                waitcredits = super.imageUpdate(img, infoflags, x, y, width, height);
                return waitcredits;
        }
        public void mousePressed(MouseEvent e) {
                --System.out.println("show buttons");
                buttonpanel.setVisible(true);
                validate();
        }
        
        public void componentResized(ComponentEvent e) {
                if (dmmap!=null) {
                        dmmap.updateSize();
                        dmmap.invalidate();
                        vspacebox.invalidate();
                        mappane.validate();
                        if (mappane.isVisible()) {
                                validate();
                                repaint();
                        }
                }
        }
--        public void componentMoved(ComponentEvent ev) {
--                if (currentDevice.getFullScreenWindow()!=null) {
--                        Component comp = (Component) ev.getSource();    
--                        comp.setLocation(frameLocation.x, frameLocation.y);
--                }
--        }
        
        public void mouseEntered(MouseEvent e) {}
        public void mouseExited(MouseEvent e) {}
        public void mouseClicked(MouseEvent e) {}
        public void mouseReleased(MouseEvent e) {}
        public void componentHidden(ComponentEvent e) {}
        public void componentShown(ComponentEvent e) {}