require "Cinegy/version"
require 'happymapper'
require 'nokogiri'
require "uuidtools"
require 'rubygems'
require 'streamio-ffmpeg'


module Enumerable
  def each_with_previous
    self.inject(nil){|prev, curr| yield prev, curr; curr}
    self
  end
end

module Cinegy



def self.change_spotfile(pl,pp )


end


def self.save_pl(pl,path)
    file = File.new(path, "wb")
    puts file.write(pl.to_xml)
    puts file.close
end

  # Your code goes here...
 def self.addzero(val)
      newval=""
      if val.to_i <= 9 and not val == "ff"
        newval="0"+val.to_s
      else
        return val
      end
    return newval
end


  def to_op(a)
    Nokogiri::XML(a.to_xml).root.to_xml
    a = HappyMapper.parse(pl.programs[0].blocks[0].items[0].events.event[0].op2)
  end


  def self.append_item(pl, item)
    pl.programs.last.blocks.last.items.push(item)
  end

 def self.convert_to_frames_tc(timecode)


        frames =0


        #Split the timecode string into it's component parts. NOTE: The string must
        #be in the form hh:mm:ss:ff otherwise an error will occur.
         tc = timecode.split(":")

        #The following are based on 25 fps.
        frames = (tc[0].to_i * 90000 + tc[1].to_i* 1500) + tc[2].to_i * 25 + tc[3].to_i



        return frames


  end

    def self.add_timecode(timecode1, timecode2)
        tc1 ,tc2 = 0
        tc1 = self.convert_to_frames(timecode1)
        tc2 = self.convert_to_frames(timecode2)
        return self.convert_from_frames(tc1 + tc2)
  end
  def self.diff_timecode(timecode1, timecode2)
        
        tc1 ,tc2 = 0
        tc1 = self.convert_to_frames(timecode1)
        tc2 = self.convert_to_frames(timecode2)
        return self.convert_from_frames(tc1 - tc2)
  end

    def self.convert_to_frames(timecode,semicolon=false)

          frames =0

          #Split the timecode string into it's component parts. NOTE: The string must
          #be in the form hh:mm:ss:ff otherwise an error will occur.
          unless semicolon
           tc = timecode.split(":")
          else
           tc =timecode.split(";")
          end

          #The following are based on 25 fps.
          frames = (tc[0].to_i * 90000 + tc[1].to_i* 1500) + tc[2].to_i * 25 + tc[3].to_i


          return frames


      end

       def self.convert_from_frames(frames)

        intHours, intMins, intSecs, intFrames, intTmp=0
        timecode =""

        #Convert frames to hours, minutes and seconds.

        #Total number of seconds
        intSecs = (frames / 25).to_i

        #Total number of minutes
        intMins = (intSecs / 60).to_i

        #Total number of hours
        intHours = (intSecs / 3600).to_i

        #Number of secs remaining after subtracting  number of mins.
        intSecs = ((frames / 25) - (intMins * 60)).to_i

        #Number of mins remaining after subtracting number of hours.
        intMins = intMins - (intHours * 60)

        #Determine the number of frames remaining after subtracting hours,mins and secs
        intTmp = intSecs * 25
        intTmp = intTmp + (intMins * 60 * 25)
        intTmp = intTmp + (intHours * 60 * 60 * 25)
        intFrames = frames - intTmp

        #Convert to string, adding leading 0 where value is less than 10,and separating with ':'
        timecode = addzero(intHours.to_s)  + ":" + addzero(intMins.to_s) + ":" + addzero(intSecs.to_s) + ":" + addzero(intFrames.to_s)
        return timecode
  end

 def self.convert_to_seconds(timecode)
    frames = convert_to_frames(timecode)
    seconds = frames / 25.00
    return seconds
 end  

 def self.convert_from_seconds(seconds)
        arr_time = seconds.to_s.split('.')
        puts arr_time.inspect
        frames_ = (arr_time[1].to_f/100 * 25).to_i.round(1).to_i
        puts frames_

        frames = (arr_time[0].to_i * 25) + frames_ #+ frames_

        intHours, intMins, intSecs, intFrames, intTmp=0
        timecode =""

        #Convert frames to hours, minutes and seconds.

        #Total number of seconds
        intSecs = (frames / 25).to_i

        #Total number of minutes
        intMins = (intSecs / 60).to_i

        #Total number of hours
        intHours = (intSecs / 3600).to_i

        #Number of secs remaining after subtracting  number of mins.
        intSecs = ((frames / 25) - (intMins * 60)).to_i

        #Number of mins remaining after subtracting number of hours.
        intMins = intMins - (intHours * 60)

        #Determine the number of frames remaining after subtracting hours,mins and secs
        intTmp = intSecs * 25
        intTmp = intTmp + (intMins * 60 * 25)
        intTmp = intTmp + (intHours * 60 * 60 * 25)
        intFrames = frames - intTmp

        #Convert to string, adding leading 0 where value is less than 10,and separating with ':'
        timecode = addzero(intHours.to_s)  + ":" + addzero(intMins.to_s) + ":" + addzero(intSecs.to_s) + ":" + addzero(intFrames.to_s)
        return timecode
 end


  def self.add_item_to_block(pl,item,pos)



    new_item = item.clone
    new_item.guid = "{#{UUIDTools::UUID.random_create}}"

    pl.programs[0].blocks[pos].items.push(new_item)

  end


  def self.search_spotfile(spot_file_path)
    #spot_file_path =spot_file_path#"/Users/lello107/Documents/spotfile16.MCRlist"
    spot_list = Cinegy::Playlist.parse(File.read(spot_file_path))


    groups = []
    dur = 0
    new_start=0
    bool_picchetto = false
    start = 0
    store_last=0
    edit_index=[]

    grouppo=0
    indice=0



    spot_list.programs.each do |pr|
      pr.blocks.each do |block|
        block.items.each_with_previous do |prev_item, item|

        if item.flags == "0x10" 
          grouppo+=1
        end

        groups.push({:item=>item,:start=>item.start,:gruppo=>grouppo,:order=>indice}) 
    #if item.name.match(/Dummy/)d.select {|v| v[:gruppo] == 1}

        end
        indice+=1
      end
    end

    return groups

  end


  def self.search_name(pl_path,spot_file_path,destination_path)
    #pl_path="/Users/lello107/Documents/16aprile.MCRlist"
    pl = Cinegy::Playlist.parse(File.read(pl_path))

    spot_file = search_spotfile(spot_file_path)


    #groups = search_spotfile()


    dummies=[]
    stime = 0

    dur = 0
    new_start=0
    bool_picchetto = false
    start = 0
    store_last=0
    edit_index=[]

    gruppo=1


    pl.programs.each do |pr|
      pr.blocks.each do |block|
        block.items.each_with_previous do |prev_item, item|

        next if item == nil

        #puts "#{item.name} #{item.timeline.duration}" if item.timeline
      
        begin
          #puts "#{item.name} #{diff_timecode(item.out,item.in)}" if !item.timeline
        rescue 
          #puts "------------------------- #{item.name}"
        end

        puts "------------ > #{item.name}"

        if item.flags == "0x10" 
         
          start = convert_to_frames(item.start) if item.start != nil
          bool_picchetto=true
          new_start = start
          dur = convert_to_frames(diff_timecode(item.out,item.in)) if item.out != nil and item.in != nil

        else 
          
          if item.equal? block.items.last
            store_last = convert_to_frames(diff_timecode(item.out,item.in)) if item.out != nil and !bool_picchetto if item
          end
          if item.equal? block.items.first
            dur = store_last
          else
            dur = convert_to_frames(diff_timecode(prev_item.out,prev_item.in)) if prev_item.out != nil and prev_item.in != nil and !bool_picchetto if prev_item
          end
          new_start += dur
          new_start = new_start-2160000 if new_start > 2160000
          bool_picchetto=false

        end 
  
          index = block.items.index(item)+1
          if item.name.match(/Dummy/)

            tolereance = "00:21:00:00"
             g = spot_file.select {|v| v[:gruppo] == gruppo}.sort_by {|i| i[:order]}.reverse!.map{|x| x[:item]}

             #diff = convert_to_frames(g.first.start.gsub(";",":")) - new_start


            #if(diff > convert_to_frames(tolereance))
              #print "index:#{index} gruppo:#{gruppo} dummy_start:#{convert_from_frames(new_start)} gruppo_start:#{g.first.start.gsub(";",":")} differenza:#{convert_from_frames(diff)}\n " if g.size>0
            #else
          

                block.items.delete_at(index-1)
                                  
                 #dummies.push({:item=>item,:start=>convert_from_frames(new_start)}) 

                 #print "index:#{index} gruppo:#{gruppo} dummy_start:#{convert_from_frames(new_start)} gruppo_start:#{g.first.start.gsub(";",":")}\r " if g.size>0
                 #sleep(0.2)

                 g.each_with_index do |spot_item,i|
                  spot_item.flags="0"
                  spot_item.comment="#{spot_item.start.gsub(";",":")}"
                  block.items.insert(index,spot_item)
                 end

                 gruppo+=1

           # end


             
          end



        end
      end
    end

    #return dummies
    save_pl(pl,destination_path)

  end



  def self.new_item(file)

    file_video = FFMPEG::Movie.new(file)
    path = file_video.path.gsub('/Volumes/','//192.168.170.200/').gsub('/', '\\')
    dur  = file_video.duration

    audiomatrix = Cinegy::AudioMatrix.new
    audiomatrix.name="Default 8"
    audiomatrix.description="Default mapping, 8 channels, direct"
    audiomatrix.value="1,0,0,0,0,0,0,0;0,1,0,0,0,0,0,0;0,0,1,0,0,0,0,0;0,0,0,1,0,0,0,0;0,0,0,0,1,0,0,0;0,0,0,0,0,1,0,0;0,0,0,0,0,0,1,0;0,0,0,0,0,0,0,1"
    audiomatrix.default="True"


    track = Cinegy::Track.new

    quality = Cinegy::Quality.new
    quality.src=path
    quality.id="0"


    timeline = Cinegy::Timeline.new
    timeline.duration = dur
    timeline.version = "4"
    timeline.groups = []

    clip = Cinegy::Clip.new
    clip.srcref="0"
    clip.start="0"
    clip.stop=dur
    clip.mstart="0"
    clip.mstop=dur


    clip.quality = quality
    track.clip=clip



    item = Cinegy::Item.new
    item.name = File.basename(file_video.path, ".*")
    item.guid = "{#{UUIDTools::UUID.random_create}}"
    item.type = "clip"
    item.flags = "0"
    item.in =   "00:00:00:00"
    item.out = convert_from_frames(dur)
    item.src_in="00:00:00:00" 
    item.src_out=convert_from_frames(dur)
    item.src_path = path
    item.FrameRate= "25"
    item.Aspect="16:9"
    item.AudioMatrix=audiomatrix
    item.ActiveAspect="16:9"


    group = Cinegy::Group.new
    group.type="video" 
    group.width=file_video.width
    group.height=file_video.height
    group.aspect="16:9" 
    group.framerate="25" 
    group.progressive="n"
    group.tracks = []


    ##AUDIO## CH1

    group_a = Cinegy::Group.new
    group_a.type="audio" 
    group_a.channels="1"
    group_a.tracks = []

    track_a = Cinegy::Track.new
    
    clip_a = Cinegy::Clip.new
    clip_a.srcref="1"
    clip_a.start="0"
    clip_a.stop=dur
    clip_a.mstart="0"
    clip_a.mstop=dur

    quality_a = Cinegy::Quality.new
    quality_a.src=path
    quality_a.id="0"

    clip_a.quality = quality_a
    track_a.clip=clip_a

    ##AUDIO## CH2

    group_a2 = Cinegy::Group.new
    group_a2.type="audio" 
    group_a2.channels="1"
    group_a2.tracks = []

    track_a2 = Cinegy::Track.new
    
    clip_a2 = Cinegy::Clip.new
    clip_a2.srcref="2"
    clip_a2.start="0"
    clip_a2.stop=dur
    clip_a2.mstart="0"
    clip_a2.mstop=dur

    quality_a2 = Cinegy::Quality.new
    quality_a2.src=path
    quality_a2.track="1"
    quality_a2.id="0"

    clip_a2.quality = quality_a2
    track_a2.clip=clip_a2

    group.tracks.push(track)
    group_a.tracks.push(track_a)
    group_a2.tracks.push(track_a2)


    timeline.groups.push(group)
    timeline.groups.push(group_a)
    timeline.groups.push(group_a2)
    
    item.timeline = timeline

    return item

  end

  def self.new_playlist

    pl = Cinegy::Playlist.new
    pl.guid = "{#{UUIDTools::UUID.random_create}}"
    pl.version = "2"
    pl.TV_Format = "1920x1080 16:9 25i"
    
    pl.programs=[]


    program = Cinegy::Program.new
    program.name = "AUTO GENERATED"
    program.guid = "{#{UUIDTools::UUID.random_create}}"
    program.blocks=[]

    block = Cinegy::Block.new
    block.name = "AUTO GENERATED"
    block.guid = "{#{UUIDTools::UUID.random_create}}"
    block.items=[]


    audiomatrix = Cinegy::AudioMatrix.new
    audiomatrix.name="Default 8"
    audiomatrix.description="Default mapping, 8 channels, direct"
    audiomatrix.value="1,0,0,0,0,0,0,0;0,1,0,0,0,0,0,0;0,0,1,0,0,0,0,0;0,0,0,1,0,0,0,0;0,0,0,0,1,0,0,0;0,0,0,0,0,1,0,0;0,0,0,0,0,0,1,0;0,0,0,0,0,0,0,1"
    audiomatrix.default="True"


    item = Cinegy::Item.new
    item.name = "All Or Nothing"
    item.guid = "{#{UUIDTools::UUID.random_create}}"
    item.type = "clip"
    item.flags = "0"
    item.in =   "00:00:00:00"
    item.out = "00:40:04:17"
    item.src_in="00:00:00:00" 
    item.src_out="00:40:04:17"
    item.src_path = "X:\\201302\\All Or Nothing.mxf"
    item.FrameRate= "25"
    item.Aspect="16:9"
    item.AudioMatrix=audiomatrix
    item.ActiveAspect="16:9"


    timeline = Cinegy::Timeline.new
    timeline.duration = "2404.68"
    timeline.version = "4"
    timeline.groups = []

    group = Cinegy::Group.new
    group.type="video" 
    group.width="1920" 
    group.height="1080" 
    group.aspect="16:9" 
    group.framerate="25" 
    group.progressive="n"
    group.tracks = []

    track = Cinegy::Track.new
    
    clip = Cinegy::Clip.new
    clip.srcref="0"
    clip.start="0"
    clip.stop="2404.68"
    clip.mstart="0"
    clip.mstop="2404.68"

    quality = Cinegy::Quality.new
    quality.src="\\\\192.168.170.200\\BikeVideo\\201302\\All Or Nothing.mxf" 
    quality.id="0"

    clip.quality = quality
    track.clip=clip

    

    ##AUDIO## CH1

    group_a = Cinegy::Group.new
    group_a.type="audio" 
    group_a.channels="1"
    group_a.tracks = []

    track_a = Cinegy::Track.new
    
    clip_a = Cinegy::Clip.new
    clip_a.srcref="1"
    clip_a.start="0"
    clip_a.stop="2404.68"
    clip_a.mstart="0"
    clip_a.mstop="2404.68"

    quality_a = Cinegy::Quality.new
    quality_a.src="\\\\192.168.170.200\\BikeVideo\\201302\\All Or Nothing.mxf" 
    quality_a.id="0"

    clip_a.quality = quality_a
    track_a.clip=clip_a

    ##AUDIO## CH2

    group_a2 = Cinegy::Group.new
    group_a2.type="audio" 
    group_a2.channels="1"
    group_a2.tracks = []

    track_a2 = Cinegy::Track.new
    
    clip_a2 = Cinegy::Clip.new
    clip_a2.srcref="2"
    clip_a2.start="0"
    clip_a2.stop="2404.68"
    clip_a2.mstart="0"
    clip_a2.mstop="2404.68"

    quality_a2 = Cinegy::Quality.new
    quality_a2.src="\\\\192.168.170.200\\BikeVideo\\201302\\All Or Nothing.mxf" 
    quality_a2.track="1"
    quality_a2.id="0"
  

    clip_a2.quality = quality_a2
    track_a2.clip=clip_a2


    group.tracks.push(track)
    group_a.tracks.push(track_a)
    group_a2.tracks.push(track_a2)


    timeline.groups.push(group)
    timeline.groups.push(group_a)
    timeline.groups.push(group_a2)
    
    item.timeline = timeline
    block.items.push(item)
    program.blocks.push(block)
    pl.programs.push(program)



    return pl


  end


  def self.insert_luminose(pl,trigger="#",items=[],type_template="X:\\CinegyType\\Luminosa.CinType")
    
      #variabile forzata
      override=true

      reg_exp = Regexp.new(/(#{trigger})(.*)(#{trigger})/)
      ## OGNI PROGRAMMA
      pl.programs.each do |program|
        ## OGNI BLOCCO
        program.blocks.each do |block|
          ## OGNI PROGRAMMA ##
          block.items.each do |item|
              begin
                puts "#{item.name} -- #{item.comment}"
                if(item.comment!="" or item.comment != nil)
                  start,testo,fine = item.comment.match(reg_exp).captures 
                  if(start==trigger and fine == trigger)
                    self.luminosa(item,testo.upcase,type_template)
                    override=false
                  else
                    override=true
                  end
                end


              rescue Exception => e

                  result = items.select{|p| p.name == item.name}
                  if(result.size>0 and override==true)
                    self.luminosa(item,result.first.name.upcase,type_template)
                  end
                  override=true
                 puts e
              end

          end
          ## FINE OGNI CLIP 
        end
        ## FINE OGNI BLOCCO
      end
      ## FINE OGNI PROGRAMMA
  end

  def self.luminosa(item, testo_luminosa,type_template)

  if(item.timeline!=nil)
    event = Cinegy::Event.new
    event.offset="+0"
    event.device="*CG_LOGO"
    event.cmd="SHOW"
    event.name="LUMINOSA"
    event.description="Luminosa inserita dal sistema"
    event.id = "{#{UUIDTools::UUID.random_create}}"
    event.skip="0"
    event.op1=type_template
    event.op2="<variables><var name=\"Text.Text.Value\" type=\"Text\" value=\"#{testo_luminosa}\"/></variables>"
  end



    if(item.timeline!=nil)
      if(item.timeline.groups!=nil)
        durata = diff_timecode(item.out,item.in)
        durata = convert_to_seconds(durata)
        valore_out =(durata*10000000).to_i #(item.timeline.groups.first.tracks.first.clip.stop.to_f * 10000000).to_i
        event_out = Cinegy::Event.new
        event_out.offset="+#{valore_out}"
        event_out.device="*CG_LOGO"
        event_out.cmd="HIDE"
        event_out.name="LUMINOSA"
        event_out.description="Luminosa inserita dal sistema"
        event_out.id = "{#{UUIDTools::UUID.random_create}}"
        event_out.skip="0"
        event_out.op1="HIDE"
        event_out.op2="<variables></variables>"
      end
    end
    #return events

    events = Cinegy::Events.new
    events.event=[]
    events.event.push(event)
    events.event.push(event_out)

    item.events = events

  end

  def self.add_block_and_program(pl,item)
    b = Cinegy::Block.new
    pl.programs[0].blocks.push(b)
    b.name = "TEST"
    b.guid = "{#{UUIDTools::UUID.random_create}}"

    new_item = item.clone

    b.items = new_item
    new_item.guid = "{#{UUIDTools::UUID.random_create}}"

  end

  # def self.save_pl(pl)
  #   file = File.new("/Users/lello107/Documents/my_xml_data_file.MCRlist", "wb")
  #   puts file.write(pl.to_xml)
  #   puts file.close
  # end

  def self.print_items(playlist)
     playlist.programs[0].blocks.each do |block|
      block.items.each do |item|
        puts "#{item.name} -- #{item.src_path}"
      end
    end
  end

  def self.clona_e_cambia(item)
    new_item = item.clone
    new_item.guid = "#{UUIDTools::UUID.random_create}"
    return new_item
  end

  class Logo
    include HappyMapper

    tag :logo

    attribute :fmt, String
    attribute :src, String
    attribute :loop, String
    attribute :fade, String

  end

  class Op1
    include HappyMapper

    tag :op1

    element :logoset, String
    has_many :logo, Logo

  end


  class Var
    include HappyMapper

    tag :var

    attribute :name, String
    attribute :type, String
    attribute :valore, String, :tag => 'value'

  end

  class Op2
    include HappyMapper

    tag :variables
    has_many :var, Var#,:xpath=>"/var"

    #def variables
    #  Var.parse(@var) 
    #end

  end

  class Event
    include HappyMapper

    tag :event

    attribute :offset, String
    attribute :device, String,:state_when_nil=>false
    attribute :cmd, String, :state_when_nil=>false
    attribute :name, String, :state_when_nil=>false
    attribute :description, String, :state_when_nil=>false
    attribute :id, String, :state_when_nil=>false
    attribute :skip, String, :state_when_nil=>false

    element 'op1', String , :state_when_nil=>false, :on_save => lambda { |op1|
      if op1.class == String
        return op1
      else op1.class == Class
        return Nokogiri::XML(op1.to_xml).root.to_xml
      end
    }

    has_one 'op2', String, :state_when_nil=>false#, :on_save => lambda {|op2|  Nokogiri::XML(op2.to_xml).root.to_xml if op2 }

    def op1
      valore =@op1
      if @device.start_with?('*CG')
        
      else
        valore = HappyMapper.parse(@op1) 
      end
      return valore
    end

    def parse_op2
     return Cinegy::Op2.parse(@op2)
    end

    def op2_string(op2)
     return Nokogiri::XML(op2.to_xml).root.to_xml
    end
   # def op2
   #   valore =@op2
   #   if @device.start_with?('*CG')
   #      valore = HappyMapper.parse(@op2) 
   #   else
   #   
   #   end
   #   return valore
   # end
  end

  class Events
    include HappyMapper

    tag :events
    
    has_many 'event', Event

  end

  class Quality
  	include HappyMapper

  	tag :quality

  	attribute :src, String
    attribute :track, String,:state_when_nil=>false
    attribute :id, String

  end


  class Clip
  	include HappyMapper

  	tag :clip

    attribute :srcref, String
    attribute :start, String
    attribute :stop, String
    attribute :mstart, String
    attribute :mstop, String



  	has_one :quality, Quality

  end

  class Track
  	include HappyMapper

  	tag :track

  	has_one :clip, Clip

  end

  class Group
  	include HappyMapper

  	tag :group

  	attribute :type, String
  	attribute :width, String,:state_when_nil=>false
  	attribute :height, String, :state_when_nil=>false
  	attribute :aspect, String, :state_when_nil=>false
  	attribute :framerate, String, :state_when_nil=>false
    attribute :startline, String, :state_when_nil=>false
  	attribute :progressive, String, :state_when_nil=>false
  	attribute :channels, String, :state_when_nil=>false

  	has_many 'tracks', Track

  end


  class Timeline
  	include HappyMapper

  	tag :timeline

  	attribute :duration, String
  	attribute :version, String

  	has_many 'groups', Group

  end

  class AudioMatrix
    include HappyMapper

    tag 'AudioMatrix'

    attribute :name, String
    attribute :description, String  
    attribute :value, String
    attribute :default, String

  end

  class Item
  	include HappyMapper
  	tag :item


    attribute :name, String
    attribute :src_in, String
    attribute :src_out, String
  	attribute :in, String
  	attribute :out, String
    attribute :type, String
    attribute :flags, String

  	attribute :start, String


  	

  	element :guid, String
  	element 'FrameRate', String
  	element 'Aspect', String


  	has_one 'timeline', Timeline

    #has_one 'events', Events


  	element :src_path, String
  	element :src_modified, String
    element :comment, String

    element :third_party_id, String

  	element 'AudioMatrix', AudioMatrix
    element 'ActiveAspect',String

    has_one :events, Events

  end


  class Block
  	include HappyMapper

  	tag 'block'
  	attribute :name, String
  	attribute :type, String

  	element :guid, String

  	has_many 'items', Item, :state_when_nil=>true

  end

  class Program
  	include HappyMapper

  	tag 'program'
  	attribute 'name', String
  	element 'guid', String
  	element 'detailKey', String, :state_when_nil => false
  	has_many 'blocks', Block, :state_when_nil => false
  end

  class Playlist
	include HappyMapper

	  

  	tag 'mcrs_playlist'
  	register_namespace "csns", "http://schemas.cinegy.com/2014/" 	  
  	attribute 'type', String, :namespace 	=> 'csns'
  	element :guid, String
  	element 'version', String, :state_when_nil => true
  	element 'TV_Format', String, :state_when_nil => true
  	has_many 'programs', Program, :state_when_nil => false
  	  
    # generate a random guid code for cinegy
    #
    #def guid
    #  "#{UUIDTools::UUID.random_create}"
    #end

  def save_pl()
    file = File.new("/Users/lello107/Documents/my_xml_data_file.MCRlist", "wb")
    puts file.write(self.to_xml)
    puts file.close
  end

  # def puts_comments
  # comments = []  

  # self.programs.each_with_index do |pr,i|
  #    pr.blocks.each_with_index do |bl,e|
  #      bl.items.each_with_index do |item,x|
  #        comments.push({:programs=>i,:blocks=>e, :item=>x, :comment=>item.comment,:item=>item})
  #      end
  #    end
  #  end
  #  return comments
  # end

  def append_item(item)
    self.programs.last.blocks.last.items.push(item)
  end

  end

  class Playlist2
  include HappyMapper

    

    tag 'mcrs_playlist'
    #register_namespace "csns", "http://schemas.cinegy.com/2014/"    
    #attribute 'type', String, :namespace  => 'csns'
    element :guid, String
    element 'version', String, :state_when_nil => true
    element 'TV_Format', String, :state_when_nil => true
    has_many 'events', Event, :xpath=>'/program/block/item'
      
    # generate a random guid code for cinegy
    #
    def guid
      "{#{UUIDTools::UUID.random_create}}"
    end



  end


def self.prova
	c = Cinegy::Playlist.parse(File.read("/Users/lello107/Documents/myList.Default--15.26.49.555--8.1.2016.MCRList"))
end
end
