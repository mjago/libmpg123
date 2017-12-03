# coding: utf-8

require "./libmpg123/*"

@[Link("mpg123")]
lib LibMPG
  alias MPG_Export = Void
  alias CInt = LibC::Int
  alias CLong = LibC::Long
  alias CFloat = LibC::Float
  alias CDouble = LibC::Double
  alias CChar = LibC::Char
  alias CUChar = LibC::UChar
  alias MPG_Handle = LibC::Int
  alias Size = CLong
  alias Offset = CLong

  fun plain_error_str = mpg123_plain_strerror(code : CInt) : CChar*
  fun error_str = mpg123_strerror(hndl : MPG_Handle) : CChar*
  fun init = mpg123_init : CInt
  fun exit = mpg123_exit : CInt
  fun decoders = mpg123_decoders : CChar**
  fun supported_decoders = mpg123_supported_decoders : CChar**
  fun current_decoder = mpg123_current_decoder(handle : MPG_Handle*) : CChar*
  fun new = mpg123_new(decoder : CChar*, err : CInt*) : MPG_Handle*
  fun open = mpg123_open(MPG_Handle*, path : CChar*) : CInt
  fun read = mpg123_read(MPG_Handle*, outmemory : CChar*, outmemsize : Size, done : Size*) : CInt
  fun encsize = mpg123_encsize(encoding : CInt) : CInt
  fun feed = mpg123_feed(MPG_Handle*, CUChar*, Size) : CInt
  fun open_feed = mpg123_open_feed(MPG_Handle*) : CInt
  fun delete = mpg123_delete(mh : MPG_Handle*) : Void
  fun param = mpg123_param(mh : MPG_Handle*, type : PARMS, value : CLong, fvalue : CDouble) : Void
  fun buf_size = mpg123_outblock(MPG_Handle*) : Size
  fun get_format = mpg123_getformat(MPG_Handle*, rate : CLong*, channels : CInt*, encoding : CInt*) : CInt
  fun decode_frame = mpg123_decode_frame(MPG_Handle*, Offset*, CUChar**, Size*) : CInt
  fun decode = mpg123_decode(MPG_Handle*, CUChar*, Size, CUChar*, Size, Size*) : CInt
  fun meta_free = mpg123_meta_free(MPG_Handle*) : CInt
  fun byte_offset = mpg123_tell_stream(MPG_Handle*) : Offset
  fun sample_offset = mpg123_tell(MPG_Handle*) : Offset
  fun time_frame = mpg123_timeframe(MPG_Handle*, sec : CDouble) : Offset
  fun frame_position = mpg123_framepos(MPG_Handle*) : Offset
  fun seek_sample = mpg123_seek(MPG_Handle*, sampleoff : Offset, whence : CInt) : Offset

  enum SEEK
    Set = 0
    Cur = 1
    End = 2
  end

  enum PARMS
    VERBOSE   = 0
    FLAGS     = 0
    ADD_FLAGS    FORCE_RATE
    DOWN_SAMPLE    RVA
    DOWNSPEED    UPSPEED
    START_FRAME    DECODE_FRAMES
    ICY_INTERVAL    OUTSCALE
    TIMEOUT    REMOVE_FLAGS
    RESYNC_LIMIT    INDEX_SIZE
    PREFRAMES    FEEDPOOL
    FEEDBUFFER
  end

  enum ParamFlags
    FORCE_MONO          =     0x7
    MONO_LEFT           =     0x1
    MONO_RIGHT          =     0x2
    MONO_MIX            =     0x4
    FORCE_STEREO        =     0x8
    FORCE_8BIT          =    0x10
    QUIET               =    0x20
    GAPLESS             =    0x40
    NO_RESYNC           =    0x80
    SEEKBUFFER          =   0x100
    FUZZY               =   0x200
    FORCE_FLOAT         =   0x400
    PLAIN_ID3TEXT       =   0x800
    IGNORE_STREAMLENGTH =  0x1000
    SKIP_ID3V2          =  0x2000
    IGNORE_INFOFRAME    =  0x4000
    AUTO_RESAMPLE       =  0x8000
    PICTURE             = 0x10000
    NO_PEEK_END         = 0x20000
    FORCE_SEEKABLE      = 0x40000
  end

  enum Param_RVA
    OFF   = 0
    MIX   = 1
    ALBUM = 2
    MAX   = ALBUM
  end

  enum Errors
    DONE              = -12
    NEW_FORMAT        = -11
    NEED_MORE         = -10
    ERR               =  -1
    OK                =   0
    BAD_OUTFORMAT
    BAD_CHANNEL
    BAD_RATE
    ERR_16TO8TABLE
    BAD_PARAM
    BAD_BUFFER
    OUT_OF_MEM
    NOT_INITIALIZED
    BAD_DECODER
    BAD_HANDLE
    NO_BUFFERS
    BAD_RVA
    NO_GAPLESS
    NO_SPACE
    BAD_TYPES
    BAD_BAND
    ERR_NULL
    ERR_READER
    NO_SEEK_FROM_END
    BAD_WHENCE
    NO_TIMEOUT
    BAD_FILE
    NO_SEEK
    NO_READER
    BAD_PARS
    BAD_INDEX_PAR
    OUT_OF_SYNC
    RESYNC_FAIL
    NO_8BIT
    BAD_ALIGN
    NULL_BUFFER
    NO_RELSEEK
    NULL_POINTER
    BAD_KEY
    NO_INDEX
    INDEX_FAIL
    BAD_DECODER_SETUP
    MISSING_FEATURE
    BAD_VALUE
    LSEEK_FAILED
    BAD_CUSTOM_IO
    LFS_OVERFLOW
    INT_OVERFLOW
  end

  enum Feature_set
    FEATURE_ABI_UTF8OPEN      = 0
    FEATURE_OUTPUT_8BIT
    FEATURE_OUTPUT_16BIT
    FEATURE_OUTPUT_32BIT
    FEATURE_INDEX
    FEATURE_PARSE_ID3V2
    FEATURE_DECODE_LAYER1
    FEATURE_DECODE_LAYER2
    FEATURE_DECODE_LAYER3
    FEATURE_DECODE_ACCURATE
    FEATURE_DECODE_DOWNSAMPLE
    FEATURE_DECODE_NTOM
    FEATURE_PARSE_ICY
    FEATURE_TIMEOUT_READ
    FEATURE_EQUALIZER
  end
end

module Libmpg123
  class Mpg123
    @handle : Pointer(LibMPG::MPG_Handle) | Nil
    #  @error  : Int32

    property handle

    #  property error

    def initialize
      @error = LibMPG.init
    end

    def plain_error_str
      String.new(LibMPG.plain_error_str(@error))
    end

    def decoders
      LibMPG.decoders
    end

    def supported_decoders
      LibMPG.supported_decoders
    end

    def decoder(val)
      (decoders + 1).value
    end

    def new(decoder)
      @handle = LibMPG.new(nil, pointerof(@error))
    end

    def open(path)
      LibMPG.open(@handle, path)
    end

    def read(bufp, buf_size, donep)
      LibMPG.read(@handle, bufp, buf_size, donep)
    end

    def feed(buf, size)
      LibMPG.feed(@handle, buf, size)
    end

    def open_feed
      LibMPG.open_feed(@handle)
    end

    def decode_frame(num, audio, bytes)
      LibMPG.decode_frame(@handle, num, audio, bytes)
    end

    def get_format(ratep, channelsp, encodingp)
      @error = LibMPG.get_format(@handle, ratep, channelsp, encodingp)
    end

    def encsize(encoding)
      LibMPG.encsize(encoding)
    end

    def buf_size
      LibMPG.buf_size(@handle)
    end

    def decode(in_buf, in_size, out_buf, out_size, done)
      LibMPG.decode(@handle, in_buf, in_size, out_buf, out_size, done)
    end

    def meta_free
      LibMPG.meta_free(@handle)
    end

    def exit
      LibMPG.exit
    end

    def time_frame(seconds)
      LibMPG.time_frame(@handle, seconds)
    end

    def frame_position
      LibMPG.frame_position(@handle)
    end

    def byte_offset
      LibMPG.byte_offset(@handle)
    end

    def sample_offset
      LibMPG.sample_offset(@handle)
    end

    def seek_sample(smp_offset, whence = :seek_set)
      seek = case whence
             when :seek_set
               LibMPG::SEEK::Set
             when :seek_cur
               LibMPG::SEEK::Cur
             when :seek_end
               LibMPG::SEEK::End
             else
               LibMPG::SEEK::Set
             end
      LibMPG.seek_sample(@handle, smp_offset, seek)
    end
  end
end
