# encoding: utf-8
CATEGORIES = [
  #level1
  [
    '中国传统音乐',
    #level2
    [
      [
        '民间音乐',
        #level3
        ['民间歌曲', '民间器乐', '民间歌舞', '戏曲音乐', '说唱音乐']
      ],
      [
        '文人音乐',
        ['古琴音乐', '诗词咏吟调', '文人自度曲']
      ],
      [
        '宗教音乐',
        ['佛教音乐', '道教音乐', '基督教音乐', '伊斯兰教音乐', '萨满教', '其他宗教音乐']
      ],
      [
        '宫廷音乐',
        ['祭祀乐', '朝会乐', '导迎乐', '巡幸乐', '宴乐']
      ]
    ]
  ],
  [
    '古典音乐',
    ['交响曲', '协奏曲', '鸣奏曲', '交响诗', '序曲', '前奏曲', '托卡塔', '幻想曲', '随想曲', '狂想曲', '夜曲', '小夜曲', '谐谑曲', '间奏曲', '赋格曲', '卡农', '回旋曲', '变奏曲', '进行曲', '晨歌', '船歌', '悲歌', '摇篮曲', '即兴曲', '无穷动', '幽默曲', '小步舞曲', '塔兰泰拉', '波尔卡', '华尔兹', '马祖卡', '波罗涅滋', '哈巴涅拉', '探戈']
  ],
  [
    '流行音乐',
    [
      [
        '爵士乐',
        ['布鲁斯', '拉格泰姆', '摇摆乐', '比博普', '冷爵士', '硬博普', '自由爵士', '现代爵士乐', '摇滚爵士', '拉丁爵士', '融合爵士', '酸爵士']
      ],
      '索尔',
      '福音歌',
      '乡村音乐',
      [
        '摇滚乐',
        ['主流摇滚', '温和摇滚', '山区摇滚', '民谣摇滚', '乡村摇滚', '重金属', '朋克', '艺术摇滚']
      ],
      [
        '舞曲',
        ['迪斯科舞曲', '耗斯舞曲', '流行舞曲', '世界音乐', '雷盖音乐', '拉丁音乐', '桑巴', '伦巴', '曼波', '萨尔萨', '恰恰', '探戈']
      ],
      '说唱乐和嘻哈音乐',
      '电子音乐',
      '环境音乐',
      '新世纪音乐',
      [
        '其他',
        ['动作/运动音乐', '喜剧/儿童音乐', '企业音乐', '喜剧/悬念音乐', '广告/铃铛音乐', '模仿音乐', '特殊应景时刻音乐', '无主题音乐/悠闲音乐']
      ]
    ]
  ]
]

c = CATEGORIES.dup

if Category
  ActiveRecord::Base.connection.execute("TRUNCATE categories")

  c = c.flatten.uniq.map do |name|
    Category.create(:name => name)
  end

  c[0].move_to_root
  c[1].move_to_child_of(c[0])
  c[2, 5].each {|i| i.move_to_child_of(c[1])}
  c[7].move_to_child_of(c[0])
  c[8, 3].each {|i| i.move_to_child_of(c[7])}
  c[11].move_to_child_of(c[0])
  c[12, 6].each {|i| i.move_to_child_of(c[11])}
  c[18].move_to_child_of(c[0])
  c[19, 5].each {|i| i.move_to_child_of(c[18])}
  c[24].move_to_root
  c[25, 34].each {|i| i.move_to_child_of(c[24])}
  c[59].move_to_root
  c[60].move_to_child_of(c[59])
  c[61, 12].each {|i| i.move_to_child_of(c[60])}
  c[73, 3].each {|i| i.move_to_child_of(c[59])}
  c[76].move_to_child_of(c[59])
  c[77, 8].each {|i| i.move_to_child_of(c[76])}
  c[85].move_to_child_of(c[59])
  c[86, 11].each {|i| i.move_to_child_of(c[85])}
  c[97, 4].each {|i| i.move_to_child_of(c[59])}
  c[101].move_to_child_of(c[59])
  c[102, 8].each {|i| i.move_to_child_of(c[101])}

end
